import 'package:flutter_test/flutter_test.dart';
import 'package:lafhub/lafhub_utils.dart';

void main() {
  group("test Either type", () {
    Either<int, String> object = Left(value: 1);
    dynamic _value;

    test("test fold", () {
      object.fold(
        onLeft: (value) => _value = value,
        onRight: (value) => _value = value,
      );
      expect(_value, 1);

      object = Right(value: "Shit");

      object.fold(
        onLeft: (value) => _value = value,
        onRight: (value) => _value = value,
      );
      expect(_value, "Shit");
    });

    test("test onLeft and onRight", () {
      object = Right(value: "Shit I hate this shit");
      object.onLeft((value) => _value = value);
      object.onRight((value) => _value = value);
      expect(_value, "Shit I hate this shit");

      object = Left(value: 69);
      object.onLeft((value) => _value = value);
      object.onRight((value) => _value = value);
      expect(_value, 69);
    });
  });

  group("test Failure", () {
    test("Initial data", () {
      final failure = Failure("Shit I hate this", Left<int, String>(value: 15));
      expect(failure.description, "Shit I hate this");
      expect(failure.data, isA<Either<int, String>>());
    });
  });
}
