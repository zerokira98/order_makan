class User {
  final String email;
  final String id;

  final String namaKaryawan;
  final String foto;
  final bool isAdmin;
  const User({
    String? email,
    String? namaKaryawan,
    String? foto,
    String? id,
    bool? isAdmin,
  })  : email = email ?? '',
        namaKaryawan = namaKaryawan ?? '',
        foto = foto ?? '',
        id = id ?? '',
        isAdmin = isAdmin ?? false;
  static const empty = User();
  Map<String, dynamic> toJson() =>
      {'email': email, 'namaKaryawan': namaKaryawan, 'foto': foto, 'id': id};
  bool get isEmpty => this == User.empty;
}
