import 'dart:io';

import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/api_handler/api_handler.dart';
import 'package:example/src/core/api_handler/api_response.dart';
import 'package:flutter/foundation.dart';

import '../utils/debug/debug_service.dart';
import 'exceptions.dart';

mixin class ErrorHandler {
  Future<ApiResponse<T>> asyncTryCatch<T>({
    required Future<ApiResponse<T>> Function() tryFunc,
  }) async {
    final ErrorResponse<T> error;
    try {
      return await tryFunc();
    } on ServerException catch (e, s) {
      error = ErrorResponse(
        message: "Server error!",
        exception: e,
        stackTrace: s
      );
    } on NoDataException catch (e, s) {
      error = ErrorResponse(
        message: "No data!",
        exception: e,
        stackTrace: s
      );
    } on SocketException catch(e, s) {
      error =
        ErrorResponse(
          exception: e,
          message: 'Internet connection failed!',
          stackTrace: s
      );
    } on DioException catch (e, s) {
      debugPrint(e.response?.data["message"].toString());
      debugPrint(e.stackTrace.toString());
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          error =
            ErrorResponse(
              exception: e,
              message: 'Connection timeout! Make sure internet is connected!',
              stackTrace: s
          );
        case DioExceptionType.receiveTimeout:
          error = ErrorResponse(
            message: 'Connection timeout! Make sure internet is connected!',
            exception: e,
            stackTrace: s,
          );
        case DioExceptionType.sendTimeout:
          error = ErrorResponse(
            message: 'Connection timeout! Make sure internet is connected!',
            exception: e,
            stackTrace: s,
          );
        case DioExceptionType.cancel:
          error = ErrorResponse(
            message: "Request cancelled!",
            exception: e,
            stackTrace: s,
          );
        default:
          error = ErrorResponse(
            message: e.response?.data["message"] ?? "Some error occured.",
            exception: e,
            stackTrace: s,
          );
      }
    } 

    debugPrint(error.toString());
    debugPrint(error.stackTrace.toString());
    return error;
  }

  // ApiResponse<T> tryCatch<T>({required T Function() tryFunc}) {
  //   try {
  //     return Right(tryFunc());
  //   } on ServerException {
  //     return Left(
  //       DataCRUDFailure(failure: Failure.severFailure, fullError: ''),
  //     );
  //   } on SocketException {
  //     return Left(
  //       DataCRUDFailure(
  //         failure: Failure.socketFailure,
  //         fullError: 'Internet connection failed!',
  //       ),
  //     );
  //   } catch (e) {
  //     return Left(
  //       DataCRUDFailure(
  //         failure: Failure.unknownFailure,
  //         fullError: 'Some error occured. Error: ${e.toString()}',
  //       ),
  //     );
  //   }
  // }

  dynamic extractBodyData(Response<dynamic> response) {
    return response.data["data"];
  }

  String? extractSuccessMessage(Response<dynamic> response, {Debugger? debugger}){
    debugger?.dekhao(response);
    try {
      return (response.data["success"] as bool) == true ? response.data["message"] as String : null;
    } catch (e) {
      debugger?.dekhao("Error from parsing success message: $e");
      return null;
    }
  }
}
