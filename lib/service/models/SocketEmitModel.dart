class SocketEmitModel {
  String emitName;

  SocketEmitModel({this.emitName});

  SocketEmitModel.fromJson(Map<String, dynamic> json) {
    emitName = json['emit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['emit_name'] = this.emitName;
    return data;
  }
}
