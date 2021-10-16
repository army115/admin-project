class Person {
  bool ok;
  Personinfo personinfo;

  Person({this.ok, this.personinfo});

  Person.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    personinfo = json['personinfo'] != null
        ? new Personinfo.fromJson(json['personinfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.personinfo != null) {
      data['personinfo'] = this.personinfo.toJson();
    }
    return data;
  }
}

class Personinfo {
  int psId;
  String psUser;
  String psPass;
  String psName;
  String psLastname;
  String psAddress;
  String psEmail;
  String psTel;

  Personinfo(
      {this.psId,
      this.psUser,
      this.psPass,
      this.psName,
      this.psLastname,
      this.psAddress,
      this.psEmail,
      this.psTel});

  Personinfo.fromJson(Map<String, dynamic> json) {
    psId = json['ps_id'];
    psUser = json['ps_user'];
    psPass = json['ps_pass'];
    psName = json['ps_name'];
    psLastname = json['ps_lastname'];
    psAddress = json['ps_address'];
    psEmail = json['ps_email'];
    psTel = json['ps_tel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ps_id'] = this.psId;
    data['ps_user'] = this.psUser;
    data['ps_pass'] = this.psPass;
    data['ps_name'] = this.psName;
    data['ps_lastname'] = this.psLastname;
    data['ps_address'] = this.psAddress;
    data['ps_email'] = this.psEmail;
    data['ps_tel'] = this.psTel;
    return data;
  }
}