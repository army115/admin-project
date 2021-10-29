class History {
  bool ok;
  List<His> his;

  History({this.ok, this.his});

  History.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['his'] != null) {
      his = new List<His>();
      json['his'].forEach((v) {
        his.add(new His.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.his != null) {
      data['his'] = this.his.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class His {
  int payId;
  String payImg;
  String payDate;
  String payTime;
  int payNum;
  double paySale;
  String payBank;
  int orId;
  String orDate;
  String orTime;
  int orNum;
  String orDetail;
  int orStatus;
  double orLat;
  double orLng;
  String orAddress;
  String orOffice;
  int uId;
  String uUser;
  String uPass;
  String uName;
  String uLastname;
  String uTel;
  String uEmail;

  His(
      {this.payId,
      this.payImg,
      this.payDate,
      this.payTime,
      this.payNum,
      this.paySale,
      this.payBank,
      this.orId,
      this.orDate,
      this.orTime,
      this.orNum,
      this.orDetail,
      this.orStatus,
      this.orLat,
      this.orLng,
      this.orAddress,
      this.orOffice,
      this.uId,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLastname,
      this.uTel,
      this.uEmail});

  His.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    payImg = json['pay_img'];
    payDate = json['pay_date'];
    payTime = json['pay_time'];
    payNum = json['pay_num'];
    paySale = json['pay_sale'];
    payBank = json['pay_bank'];
    orId = json['or_id'];
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
    data['pay_id'] = this.payId;
    data['pay_img'] = this.payImg;
    data['pay_date'] = this.payDate;
    data['pay_time'] = this.payTime;
    data['pay_num'] = this.payNum;
    data['pay_sale'] = this.paySale;
    data['pay_bank'] = this.payBank;
    data['or_id'] = this.orId;
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