class User {
  final String userId, email, name, phone;

  User({
    this.name,
    this.phone,
    this.email,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  User.fromFirestore(
    Map<String, dynamic> firestore,
  )   : userId = firestore['userId'],
        phone = firestore['phone'],
        name = firestore['name'],
        email = firestore['email'];
}
