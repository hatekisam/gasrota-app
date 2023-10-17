class UserModal {
  String uid;
  String name;
  String profileImg;
  int score, price;
  bool isAdmin;
  String org;
  List played;
  String uidtoken;
  String tlf;

  UserModal(
      {required this.profileImg,
      required this.score,
      required this.uid,
      required this.name,
      required this.org,
      required this.played,
      required this.tlf,
      required this.isAdmin,
      required this.uidtoken,
      required this.price});
}
