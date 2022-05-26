
class Profile {
  int? id;
  String? name;
  String? medical_specialty;
  String? birthday;
  String? image;

  Profile({
    this.id,
    this.name,
    this.medical_specialty,
    this.birthday,
    this.image
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'medical_specialty': medical_specialty,
      'birthday': birthday,
      'image':image
    };
  }

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    medical_specialty = json['medical_specialty'];
    birthday = json['birthday'];
    image = json['image'];
  }
}
