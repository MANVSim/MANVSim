from execution import run
from execution.entities.execution import Execution
from conftest import generate_webtoken


def test_execution_state_change(client):
    """ Tests the execution state changes of the lobby patch method. """
    auth_header = generate_webtoken(client.application)

    # PER DEFAULT
    # id=1 PENDING
    # id=2 RUNNING
    # id of {3, 4, 23456} in DB UNKNOWN

    def _test_illegal_state_changes(exec_id, unwanted_status_list):
        for unwanted_status in unwanted_status_list:
            if exec_id in run.active_executions.keys():
                status_before = run.active_executions[exec_id].status
            else:
                status_before = Execution.Status.UNKNOWN
            # test illegal state changes
            response = client.patch(f"/web/execution?id={exec_id}",
                                    headers=auth_header,
                                    data={"new_status": unwanted_status})

            assert response.status_code == 400
            if exec_id in run.active_executions.keys():
                assert run.active_executions[
                           exec_id].status == status_before
            else:
                assert exec_id not in run.active_executions.keys()

    def _test_legal_state_changes(exec_id, wanted_status_list):
        for wanted_status in wanted_status_list:
            response = client.patch(f"/web/execution?id={exec_id}",
                                    headers=auth_header,
                                    data={"new_status": wanted_status})
            assert response.status_code == 200
            assert run.active_executions[
                       exec_id].status == Execution.Status[wanted_status]

    # Status: PENDING
    # test illegal state changes
    _test_illegal_state_changes(1, ["FINISHED"])

    # test legal state changes
    _test_legal_state_changes(1, ["PENDING", "RUNNING"])

    # Status: RUNNING
    # test illegal state changes
    _test_illegal_state_changes(2, ["UNKNOWN"])

    # test legal state changes
    _test_legal_state_changes(2,
                              ["PENDING", "RUNNING", "FINISHED"])

    # Status: FINISHED
    # test illegal state changes
    run.active_executions[2].status = Execution.Status.FINISHED
    _test_illegal_state_changes(2, ["PENDING", "RUNNING", "UNKNOWN"])

    # test legal state changes
    _test_legal_state_changes(2, ["FINISHED"])

    # Status: UNKNOWN
    # test illegal state changes
    _test_illegal_state_changes(3,
                                ["RUNNING", "FINISHED", "UNKNOWN", "PENDING"])


