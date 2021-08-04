abstract class Either<L, R> {
  Either fold({required void onLeft(L), required void onRight(R)});

  Either onLeft(void onLeft(L)) {
    return this;
  }

  Either onRight(void onRight(R)) {
    return this;
  }
}

class Left<L, R> extends Either<L, R> {
  final L value;

  Left({required this.value});

  @override
  Either fold({required void onLeft(L), required void onRight(R)}) {
    return this.onLeft(onLeft);
  }

  @override
  Either onLeft(void onLeft(L)) {
    onLeft(value);
    return this;
  }
}

class Right<L, R> extends Either<L, R> {
  final R value;

  Right({required this.value});

  @override
  Either fold({required void onLeft(L), required void onRight(R)}) {
    return this.onRight(onRight);
  }

  @override
  Either onRight(void onRight(R)) {
    onRight(value);
    return this;
  }
}
