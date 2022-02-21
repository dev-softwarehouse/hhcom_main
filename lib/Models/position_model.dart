/// [PositionModel] class used in the [PositionControlller] for manage the positions list
///
class PositionModel {
  String? sId;
  String? maleJobTitle;
  String? femaleJobTitle;
  String? position;
  //String? icon;
  int? jobType;

  PositionModel({
    this.sId,
    this.maleJobTitle,
    this.femaleJobTitle,
    this.position,
    this.jobType,
    //this.icon
  });

  PositionModel.fromJson(Map<String, dynamic> json) {
    sId = json['id'];
    maleJobTitle = json['maleJobTitle'];
    femaleJobTitle = json['femaleJobTitle'];
    position = json['position'];
    jobType = json['jobtype'];

    //icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.sId;
    data['maleJobTitle'] = this.maleJobTitle;
    data['femaleJobTitle'] = this.femaleJobTitle;
    data['position'] = this.position;
    data['jobtype'] = this.jobType;
    //data['icon'] = this.icon;
    return data;
  }
}
