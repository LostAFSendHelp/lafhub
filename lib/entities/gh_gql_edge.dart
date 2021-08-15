class GHGQLEdge<T> {
  final String cursor;
  final T object;

  GHGQLEdge.fromJson(Map<String, dynamic> data)
      : cursor = data["cursor"],
        object = data["node"];
}
