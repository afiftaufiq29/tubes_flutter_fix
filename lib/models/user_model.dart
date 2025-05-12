class UserModel {
  final String name;
  final String email;
  final String phone; // Add phone field
  final String joinDate;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    this.phone = '', // Make phone optional with default value
    required this.joinDate,
    this.password = '', // Make password optional with default value
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'joinDate': joinDate,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? 'User Name',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      joinDate: json['joinDate'] ?? 'Jan 2023',
      password: json['password'] ?? '',
    );
  }
}
