// Mocks generated by Mockito 5.0.14 from annotations
// in lafhub/test/login_repo_tests.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:lafhub/datasources/local_storage.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [LocalStorageExpected].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorageExpected extends _i1.Mock
    implements _i4.LocalStorageExpected {
  MockLocalStorageExpected() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool? getBool({String? key}) =>
      (super.noSuchMethod(Invocation.method(#getBool, [], {#key: key}))
          as bool?);
  @override
  String? getString({String? key}) =>
      (super.noSuchMethod(Invocation.method(#getString, [], {#key: key}))
          as String?);
  @override
  int? getInt({String? key}) =>
      (super.noSuchMethod(Invocation.method(#getInt, [], {#key: key})) as int?);
  @override
  double? getDouble({String? key}) =>
      (super.noSuchMethod(Invocation.method(#getDouble, [], {#key: key}))
          as double?);
  @override
  _i5.Future<bool> setString(String? value, {String? key}) =>
      (super.noSuchMethod(Invocation.method(#setString, [value], {#key: key}),
          returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
  @override
  _i5.Future<bool> remove({String? key}) =>
      (super.noSuchMethod(Invocation.method(#remove, [], {#key: key}),
          returnValue: Future<bool>.value(false)) as _i5.Future<bool>);
  @override
  String toString() => super.toString();
}