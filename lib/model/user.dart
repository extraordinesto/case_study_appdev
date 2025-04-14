class User {
  int userID;
  String fullName;
  String username;
  String password;

  User(this.userID, this.fullName, this.username, this.password);

  factory User.fromJson(Map<String, dynamic> json) => User(
    int.parse(json["userID"]),
    json["fullName"],
    json["username"],
    json["password"],
  );

  Map<String, dynamic> toJson() => {
    'userID': userID.toString(),
    'fullName': fullName,
    'username': username,
    'password': password,
  };
}
