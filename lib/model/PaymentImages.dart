class Paymentimage {
  bool ok;
  Getpayimage getpayimage;

  Paymentimage({this.ok, this.getpayimage});

  Paymentimage.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    getpayimage = json['getpayimage'] != null
        ? new Getpayimage.fromJson(json['getpayimage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.getpayimage != null) {
      data['getpayimage'] = this.getpayimage.toJson();
    }
    return data;
  }
}

class Getpayimage {
  int payId;
  String payImg;
  String payDate;
  String payTime;
  double paySale;
  int orId;

  Getpayimage(
      {this.payId,
      this.payImg,
      this.payDate,
      this.payTime,
      this.paySale,
      this.orId});

  Getpayimage.fromJson(Map<String, dynamic> json) {
    payId = json['pay_id'];
    payImg = json['pay_img'];
    payDate = json['pay_date'];
    payTime = json['pay_time'];
    paySale = json['pay_sale'];
    orId = json['or_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_id'] = this.payId;
    data['pay_img'] = this.payImg;
    data['pay_date'] = this.payDate;
    data['pay_time'] = this.payTime;
    data['pay_sale'] = this.paySale;
    data['or_id'] = this.orId;
    return data;
  }
}