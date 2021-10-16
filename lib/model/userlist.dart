class UserList {
  bool ok;
  List<User> user;

  UserList({this.ok, this.user});

  UserList.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['User'] != null) {
      user = new List<User>();
      json['User'].forEach((v) {
        user.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.user != null) {
      data['User'] = this.user.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int uId;
  String uUser;
  String uPass;
  String uName;
  String uLastname;
  String uTel;
  String uEmail;

  User(
      {this.uId,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLastname,
      this.uTel,
      this.uEmail});

  User.fromJson(Map<String, dynamic> json) {
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