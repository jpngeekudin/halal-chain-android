class SimulasiLog {
  late DateTime createdAt;
  late String status;
  late List<SimulasiLogData> data;

  SimulasiLog({
    required this.createdAt,
    required this.status,
    required this.data
  });
  
  SimulasiLog.fromJSON(Map<String, dynamic> json) {
    createdAt = DateTime.fromMillisecondsSinceEpoch(json['created_at']);
    status = json['status'];
    data = json['data'].map<SimulasiLogData>((json) => SimulasiLogData.fromJSON(json)).toList();
  }
}

class SimulasiLogData {
  late String name;
  late String type;
  late bool status;
  late String detail;

  SimulasiLogData({
    required this.name,
    required this.type,
    required this.status,
    required this.detail,
  });

  SimulasiLogData.fromJSON(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    status = json['status'];
    detail = json['detail'];
  }
}