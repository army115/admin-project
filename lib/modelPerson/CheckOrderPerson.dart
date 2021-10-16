class CheckOrderPerson {
  bool ok;
  List<Checkperson> checkperson;

  CheckOrderPerson({this.ok, this.checkperson});

  CheckOrderPerson.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['checkperson'] != null) {
      checkperson = new List<Checkperson>();
      json['checkperson'].forEach((v) {
        checkperson.add(new Checkperson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.checkperson != null) {
      data['checkperson'] = this.checkperson.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Checkperson {
  int checkId;
  int checkNum;
  String checkDate;
  String checkTime;
  int orId;
  int psId;
  String orDate;
  String orTime;
  int orNum;
  String orDetail;
  String orOffice;
  int orStatus;
  double orLat;
  double orLng;
  String orAddress;
  int uId;
  String uUser;
  String uPass;
  String uName;
  String uLastname;
  String uTel;
  String uEmail;

  Checkperson(
      {this.checkId,
      this.checkNum,
      this.checkDate,
      this.checkTime,
      this.orId,
      this.psId,
      this.orDate,
      this.orTime,
      this.orNum,
      this.orDetail,
      this.orOffice,
      this.orStatus,
      this.orLat,
      this.orLng,
      this.orAddress,
      this.uId,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLastname,
      this.uTel,
      this.uEmail});

  Checkperson.fromJson(Map<String, dynamic> json) {
    checkId = json['check_id'];
    checkNum = json['check_num'];
    checkDate = json['check_date'];
    checkTime = json['check_time'];
    orId = json['or_id'];
    psId = json['ps_id'];
    orDate = json['or_date'];
    orTime = json['or_time'];
    orNum = json['or_num'];
    orDetail = json['or_detail'];
    orStatus = json['or_status'];
    orLat = json['or_lat'];
    orLng = json['or_lng'];
    orAddress = json['or_address'];
    orOffice = json['or_office'];
    uId = json['u_id'];
    uUser = json['u_user'];
    uPass = json['u_pass'];
    uName = json['u_name'];
    uLastname = json['u_lastname'];
    uTel = json['u_tel'];
    uEmail = json['u_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_id'] = this.checkId;
    data['check_num'] = this.checkNum;
    data['check_date'] = this.checkDate;
    data['check_time'] = this.checkTime;
    data['or_id'] = this.orId;
    data['ps_id'] = this.psId;
    data['or_date'] = this.orDate;
    data['or_time'] = this.orTime;
    data['or_num'] = this.orNum;
    data['or_detail'] = this.orDetail;
    data['or_status'] = this.orStatus;
    data['or_lat'] = this.orLat;
    data['or_lng'] = this.orLng;
    data['or_address'] = this.orAddress;
    data['or_office'] = this.orOffice;
    data['u_id'] = this.uId;
    data['u_user'] = this.uUser;
    data['u_pass'] = this.uPass;
    data['u_name'] = this.uName;
    data['u_lastname'] = this.uLastname;
    data['u_tel'] = this.uTel;
    data['u_email'] = this.uEmail;
    return data;
  }
}