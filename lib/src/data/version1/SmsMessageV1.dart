class SmsMessageV1 {
  String from;
  String to;
  dynamic text;

  SmsMessageV1({String from, String to, dynamic text})
      : from = from,
        to = to,
        text = text;

  void fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'from': from, 'to': to, 'text': text};
  }
}
