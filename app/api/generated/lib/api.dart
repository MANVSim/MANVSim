//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library manv_api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/default_api.dart';

part 'model/action_dto.dart';
part 'model/error.dart';
part 'model/location_dto.dart';
part 'model/login_post200_response.dart';
part 'model/login_post_request.dart';
part 'model/map_data_dto.dart';
part 'model/map_data_dto_buildings_inner.dart';
part 'model/map_data_dto_location_positions_inner.dart';
part 'model/map_data_dto_patient_positions_inner.dart';
part 'model/media_references_dto_inner.dart';
part 'model/notifications_get200_response.dart';
part 'model/patient_classification.dart';
part 'model/patient_dto.dart';
part 'model/performed_action_dto.dart';
part 'model/player_set_name_post401_response.dart';
part 'model/player_set_name_post_request.dart';
part 'model/point_dto.dart';
part 'model/resource_dto.dart';
part 'model/run_action_all_get200_response.dart';
part 'model/run_action_perform_move_patient_post_request.dart';
part 'model/run_action_perform_post200_response.dart';
part 'model/run_action_perform_post_request.dart';
part 'model/run_action_perform_result_get200_response.dart';
part 'model/run_location_all_get200_response.dart';
part 'model/run_location_leave_post200_response.dart';
part 'model/run_location_persons_get200_response.dart';
part 'model/run_location_persons_get200_response_patients_inner.dart';
part 'model/run_location_persons_get200_response_players_inner.dart';
part 'model/run_location_put_to_post_request.dart';
part 'model/run_location_take_to_post_request.dart';
part 'model/run_patient_all_ids_get200_response.dart';
part 'model/run_patient_arrive_post200_response.dart';
part 'model/run_patient_arrive_post_request.dart';
part 'model/run_patient_classify_post_request.dart';
part 'model/run_player_inventory_get200_response.dart';
part 'model/scenario_start_time_get200_response.dart';


/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) => pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
