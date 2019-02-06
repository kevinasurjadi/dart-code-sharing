class Pokemon {
  final String name;
  final String url;

  const Pokemon({this.name, this.url});

  static Pokemon fromJson(dynamic json) {
    return Pokemon(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
