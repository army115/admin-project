class Savedata {
  bool ok;
  List<Save> save;

  Savedata({this.ok, this.save});

  Savedata.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['save'] != null) {
      save = new List<Save>();
      json['save'].forEach((v) {
        save.add(new Save.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.save != null) {
      data['save'] = this.save.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Save {
  int trackId;
  String trackName;
  String trackNum;
  int trackSale;
  int orId;

  Save(
      {this.trackId, this.trackName, this.trackNum, this.trackSale, this.orId});

  Save.fromJson(Map<String, dynamic> json) {
    trackId = json['track_id'];
    trackName = json['track_name'];
    trackNum = json['track_num'];
    trackSale = json['track_sale'];
    orId = json['or_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['track_id'] = this.trackId;
    data['track_name'] = this.trackName;
    data['track_num'] = this.trackNum;
    data['track_sale'] = this.trackSale;
    data['or_id'] = this.orId;
    return data;
  }
}