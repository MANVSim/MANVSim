//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:manv_api/api.dart';
import 'package:test/test.dart';


/// tests for DefaultApi
void main() {
  // final instance = DefaultApi();

  group('tests for DefaultApi', () {
    // TAN Login
    //
    // authenticates a user with a TAN and returns a JWT token
    //
    //Future<LoginPost200Response> loginPost(LoginPostRequest loginPostRequest) async
    test('test loginPost', () async {
      // TODO
    });

    // notification polling
    //
    // Returns a list of notifications for the user after lastPollTime.
    //
    //Future<NotificationsGet200Response> notificationsGet({ DateTime lastPollTime }) async
    test('test notificationsGet', () async {
      // TODO
    });

    // Set username for the TAN
    //
    // Sets the name for the TAN provided in JWT.
    //
    //Future playerSetNamePost(PlayerSetNamePostRequest playerSetNamePostRequest, String xCSRFToken) async
    test('test playerSetNamePost', () async {
      // TODO
    });

    // Returns a list of actions available to the user.
    //
    //Future<List<Action>> runActionAllGet() async
    test('test runActionAllGet', () async {
      // TODO
    });

    // Performs an action.
    //
    //Future<RunActionPerformPost200Response> runActionPerformPost(RunActionPerformPostRequest runActionPerformPostRequest, String xCSRFToken) async
    test('test runActionPerformPost', () async {
      // TODO
    });

    // Gets the result of a performed action.
    //
    //Future<RunActionPerformResultGet200Response> runActionPerformResultGet(String performedActionId, String patientId) async
    test('test runActionPerformResultGet', () async {
      // TODO
    });

    // Returns a list of locations.
    //
    //Future<RunLocationAllGet200Response> runLocationAllGet() async
    test('test runLocationAllGet', () async {
      // TODO
    });

    // Simulates the arrival of a player at a certain location.
    //
    //Future<RunLocationArriveGet200Response> runLocationArriveGet() async
    test('test runLocationArriveGet', () async {
      // TODO
    });

    // A player 'takes' a sublocation, accessible to the players current location. It will be placed into the players inventory.
    //
    //Future<RunLocationArriveGet200Response> runLocationTakeFromGet() async
    test('test runLocationTakeFromGet', () async {
      // TODO
    });

    // Returns a list of all patients ids.
    //
    //Future<RunPatientAllIdsGet200Response> runPatientAllIdsGet() async
    test('test runPatientAllIdsGet', () async {
      // TODO
    });

    // Returns a specified patient.
    //
    //Future<RunPatientArrivePost200Response> runPatientArrivePost(int patientId) async
    test('test runPatientArrivePost', () async {
      // TODO
    });

    // Leaves a patient.
    //
    // Closes a patient profile. Other users can no longer see the username in the list of treating users.
    //
    //Future runPatientsLeavePost(String xCSRFToken, String patientId) async
    test('test runPatientsLeavePost', () async {
      // TODO
    });

    // Get start time and arrival time of scenario.
    //
    // Get start time of scenario and time to arrive/travel at the scene.
    //
    //Future<ScenarioStartTimeGet200Response> scenarioStartTimeGet() async
    test('test scenarioStartTimeGet', () async {
      // TODO
    });

  });
}
