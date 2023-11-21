class Victory {
  Victory({
    required this.docId,
    required this.victory,
    required this.date,
    required this.iconName,
  });

  factory Victory.fromJson(Map<String, dynamic> json) {
    final String docId = json['docId'] as String;
    final String victory = json['victory'] as String;
    final String date = json['date'] as String;
    final String iconName = json['iconName'] as String;

    return Victory(
      docId: docId,
      victory: victory,
      date: date,
      iconName: iconName,
    );
  }

  String docId;
  String victory;
  String date;
  String iconName;

  Iterable<Map<String, dynamic>> victoryMap(List<dynamic> list) {
    return list.map((dynamic e) {
      return <String, dynamic>{
        'docId': e.docId,
        'victory': e.victory,
        'date': e.date,
        'iconName': e.iconName,
      };
    });
  }
}
