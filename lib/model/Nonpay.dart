class Nonpay {
  bool ok;
  List<Non> non;

  Nonpay({this.ok, this.non});

  Nonpay.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['non'] != null) {
      non = new List<Non>();
      json['non'].forEach((v) {
        non.add(new Non.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.non != null) {
      data['non'] = this.non.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Non {
  int sentId;
  String sentDate;
  String sentTime;
  int sentNum;
  int sentSale;
  int checkId;
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
  String psUser;
  String psPass;
  String psName;
  String psLastname;
  String psAddress;
  String psEmail;
  String psTel;
  String uUser;
  String uPass;
  String uName;
  String uLastname;
  String uTel;
  String uEmail;

  Non(
      {this.sentId,
      this.sentDate,
      this.sentTime,
      this.sentNum,
      this.sentSale,
      this.checkId,
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
      this.psUser,
      this.psPass,
      this.psName,
      this.psLastname,
      this.psAddress,
      this.psEmail,
      this.psTel,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLastname,
      this.uTel,
      this.uEmail});

  Non.fromJson(Map<String, dynamic> json) {
    sentId = json['sent_id'];
    sentDate = json['sent_date'];
    sentTime = json['sent_time'];
    sentNum = json['sent_num'];
    sentSale = json['sent_sale'];
    checkId = json['check_id'];
    orId = json['or_id'];
    psId = json['ps_id'];
    orDate = json['or_date'];
    orTime = json['or_time'];
    orNum = json['or_num'];
    orDetail = json['or_detail'];
    orOffice = json['or_office'];
    orStatus = json['or_status'];
    orLat = json['or_lat'];
    orLng = json['or_lng'];
    orAddress = json['or_address'];
    uId = json['u_id'];
    psUser = json['ps_user'];
    psPass = json['ps_pass'];
    psName = json['ps_name'];
    psLastname = json['ps_lastname'];
    psAddress = json['ps_address'];
    psEmail = json['ps_email'];
    psTel = json['ps_tel'];
    uUser = json['u_user'];
    uPass = json['u_pass'];
    uName = json['u_name'];
    uLastname = json['u_lastname'];
    uTel = json['u_tel'];
    uEmail = json['u_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sent_id'] = this.sentId;
    data['sent_date'] = this.sentDate;
    data['sent_time'] = this.sentTime;
    data['sent_num'] = this.sentNum;
    data['sent_sale'] = this.sentSale;
    data['check_id'] = this.checkId;
    data['or_id'] = this.orId;
    data['ps_id'] = this.psId;
    data['or_date'] = this.orDate;
    data['or_time'] = this.orTime;
    data['or_num'] = this.orNum;
    data['or_detail'] = this.orDetail;
    data['or_office'] = this.orOffice;
    data['or_status'] = this.orStatus;
    data['or_lat'] = this.orLat;
    data['or_lng'] = this.orLng;
    data['or_address'] = this.orAddress;
    data['u_id'] = this.uId;
    data['ps_user'] = this.psUser;
    data['ps_pass'] = this.psPass;
    data['ps_name'] = this.psName;
    data['ps_lastname'] = this.psLastname;
    data['ps_address'] = this.psAddress;
    data['ps_email'] = this.psEmail;
    data['ps_tel'] = this.psTel;
    data['u_user'] = this.uUser;
    data['u_pass'] = this.uPass;
    data['u_name'] = this.uName;
    data['u_lastname'] = this.uLastname;
    data['u_tel'] = this.uTel;
    data['u_email'] = this.uEmail;
    return data;
  }
}