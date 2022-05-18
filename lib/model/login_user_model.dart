class LoginUserModel {
  String? uid;
  String? email;
  String? name;
  String? imageUrl;
  String? provider;

  LoginUserModel(
      {this.uid, this.email, this.name, this.imageUrl, this.provider});

  //data from server

  factory LoginUserModel.fromMap(map) {
    return LoginUserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      imageUrl: map['imageUrl'],
      provider: map['provider'],
    );
  }

  //sending data to server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'imageUrl': imageUrl,
      'provider': provider,
    };
  }
}
