class OrderImage {
  bool ok;
  Getorderimage getorderimage;

  OrderImage({this.ok, this.getorderimage});

 OrderImage.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    getorderimage = json['getorderimage'] != null
        ? new Getorderimage.fromJson(json['getorderimage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.getorderimage != null) {
      data['getorderimage'] = this.getorderimage.toJson();
    }
    return data;
  }
}

class Getorderimage {
  int imgId;
  String orImg;
  String chorImg;
  int orId;

  Getorderimage({this.imgId, this.orImg, this.chorImg, this.orId});

  Getorderimage.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    orImg = json['or_img'];
    chorImg = json['chor_img'];
    orId = json['or_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['or_img'] = this.orImg;
    data['chor_img'] = this.chorImg;
    data['or_id'] = this.orId;
    return data;
  }
}