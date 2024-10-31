class Bank {
  final String name;

  Bank(this.name);

  factory Bank.fromJson(String json) {
    return Bank(json);
  }
}
