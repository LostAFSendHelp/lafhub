abstract class Either<L, R> {
  Either fold({required void onLeft(L l), required void onRight(R r)});

  Either onLeft(void onLeft(L l)) {
    return this;
  }

  Either onRight(void onRight(R r)) {
    return this;
  }

  L? left() => null;
  R? right() => null;
}

class Left<L, R> extends Either<L, R> {
  final L value;

  Left({required this.value});

  @override
  Either fold({required void onLeft(L l), required void onRight(R r)}) {
    return this.onLeft(onLeft);
  }

  @override
  Either onLeft(void onLeft(L l)) {
    onLeft(value);
    return this;
  }

  @override
  L? left() => value;
}

class Right<L, R> extends Either<L, R> {
  final R value;

  Right({required this.value});

  @override
  Either fold({required void onLeft(L l), required void onRight(R r)}) {
    return this.onRight(onRight);
  }

  @override
  Either onRight(void onRight(R r)) {
    onRight(value);
    return this;
  }

  @override
  R? right() => value;
}
