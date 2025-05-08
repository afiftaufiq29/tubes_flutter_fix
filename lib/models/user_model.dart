class UserModel {
  final String email;
  final String password;

  UserModel({required this.email, required this.password});
}

// Data dummy pengguna
final List<UserModel> dummyUsers = [
  UserModel(email: 'user1@example.com', password: 'password123'),
  UserModel(email: 'user2@example.com', password: 'password456'),
];
