class UserModel {
  final int id;
  final String userName;
  final String userEmail;
  final String firstName;
  final String lastName;
  final String bio;
  final String path;
  final String customerId;
  final bool active;
  final String pass;
  UserModel({
    this.id,
    this.userName,
    this.userEmail,
    this.firstName,
    this.lastName,
    this.bio,
    this.path,
    this.customerId,
    this.active,
    this.pass,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    String _username = json['username'] ?? "";
    String _useremail = json['email'] ?? "";
    String _firstname = json['first_name'] ?? "";
    String _lastname = json['last_name'] ?? "";
    String _bio = json['admin_comment'] ?? "";
    String _path = json['system_name'] ?? "";
    String _customerId = json['customer_guid'] ?? "";
    String _pass = json['last_ip_address'] ?? "";
    return UserModel(
      id: json['id'],
      userName: _username,
      userEmail: _useremail,
      firstName: _firstname,
      lastName: _lastname,
      bio: _bio,
      path: _path,
      customerId: _customerId,
      active: json['active'],
      pass: _pass,
    );
  }
}
