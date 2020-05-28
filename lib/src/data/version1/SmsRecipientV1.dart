class SmsRecipientV1 {
  String id;
  String name;
  String phone;
  String language;

  SmsRecipientV1({String id, String name, String phone, String language})
      : id = id,
        name = name,
        phone = phone,
        language = language;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    language = json['language'];
  }

  factory SmsRecipientV1.fromJson(Map<String, dynamic> json) {
    return SmsRecipientV1(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        language: json['language']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'language': language
    };
  }
}
