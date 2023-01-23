class WorldWideModel {
  final String name;
  final String profilePic;
  final String uid;

  WorldWideModel({
    required this.name,
    required this.profilePic,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
    };
  }

  factory WorldWideModel.fromMap(Map<String, dynamic> map) {
    return WorldWideModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}
