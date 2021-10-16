class CheckImages {
  bool ok;
  GetCheckimage getCheckimage;

  CheckImages({this.ok, this.getCheckimage});

  CheckImages.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    getCheckimage = json['getCheckimage'] != null
        ? new GetCheckimage.fromJson(json['getCheckimage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.getCheckimage != null) {
      data['getCheckimage'] = this.getCheckimage.toJson();
    }
    return data;
  }
}

class GetCheckimage {
  int imgId;
  String orImg;
  String checkImg;
  int orId;
  int checkId;

  GetCheckimage(
      {this.imgId, this.orImg, this.checkImg, this.orId, this.checkId});

  GetCheckimage.fromJson(Map<String, dynamic> json) {
    imgId = json['img_id'];
    orImg = json['or_img'];
    checkImg = json['check_img'];
    orId = json['or_id'];
    checkId = json['check_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img_id'] = this.imgId;
    data['or_img'] = this.orImg;
    data['check_img'] = this.checkImg;
    data['or_id'] = this.orId;
    data['check_id'] = this.checkId;
    return data;
  }
}