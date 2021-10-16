class admin {
  List<Data> data;

  admin({this.data});

  admin.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>.empty();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int adId;
  String adUser;
  String adPass;
  String adEmail;
  int adTel;

  Data({this.adId, this.adUser, this.adPass, this.adEmail, this.adTel});

  Data.fromJson(Map<String, dynamic> json) {
    adId = json['ad_id'];
    adUser = json['ad_user'];
    adPass = json['ad_pass'];
    adEmail = json['ad_email'];
    adTel = json['ad_tel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ad_id'] = this.adId;
    data['ad_user'] = this.adUser;
    data['ad_pass'] = this.adPass;
    data['ad_email'] = this.adEmail;
    data['ad_tel'] = this.adTel;
    return data;
  }
}