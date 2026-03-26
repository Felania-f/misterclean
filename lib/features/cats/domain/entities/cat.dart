class Cat {
  final String id;
  final String name;
  final String origin;

//!1.2.1 KISS (Keep It Simple, Stupid))
  final String nameUpperCase;
  /*String get nameUpperCase => name.toUpperCase();
  String getnameUpperCase(){
    return name.toUpperCase();
  }*/

//!3.1.3 Avoid redundancy, nameUpperCase est redondant, peut etre deduit de nameen faisant un getters
  const Cat({
    required this.id,
    required this.name,
    required this.origin,
    this.nameUpperCase = '',
  });

  String describe() => 'Cat: $name from $origin';
}
