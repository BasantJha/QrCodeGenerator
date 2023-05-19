

class getuserInfo {
  late final String QrCodeUniqueId;
  late final String  key;

  getuserInfo({
    required this.QrCodeUniqueId,
    required this.key,
  });

  factory getuserInfo.fromJson(Map<String, dynamic> json) {
    return getuserInfo(
      QrCodeUniqueId: json[' QrCodeUniqueId'],
      key: json['key'],
    );
  }
}