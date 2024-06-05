from executions.entities.resource import Resource
from executions.utils import util


def test_decrease(client):
    resource = Resource(id=1, name="test", quantity=10000, picture_ref="")

    # test infinite
    assert resource.decrease(duration=1)
    assert resource.quantity == 10000

    # test non-infinite
    old_quantity = 10
    resource.quantity = old_quantity
    assert resource.decrease(duration=1)
    assert resource.quantity == old_quantity - 1

    # test non-infinite non-consumable only single left
    resource.quantity = 1
    assert resource.decrease(duration=1)
    assert resource.locked_until != 0

    # test consumable empty
    resource.quantity = 0
    old_locked_until = resource.locked_until
    assert not resource.decrease(duration=1)
    assert resource.locked_until == old_locked_until

    # test non-consumable empty missing increase
    resource.consumable = False
    current_millis = util.get_current_millis()
    resource.locked_until = current_millis
    assert resource.decrease(duration=100)
    assert resource.locked_until > current_millis
