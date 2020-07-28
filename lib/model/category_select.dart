class CategorySelectModel {
  String tGID;
  String gID;
  String tID;
  String name;
  String description;
  String online;
  String uRL;
  String createdDate;

  CategorySelectModel(
      {this.tGID,
      this.gID,
      this.tID,
      this.name,
      this.description,
      this.online,
      this.uRL,
      this.createdDate});

  CategorySelectModel.fromJson(Map<String, dynamic> json) {
    tGID = json['TGID'];
    gID = json['GID'];
    tID = json['TID'];
    name = json['Name'];
    description = json['Description'];
    online = json['Online'];
    uRL = json['URL'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TGID'] = this.tGID;
    data['GID'] = this.gID;
    data['TID'] = this.tID;
    data['Name'] = this.name;
    data['Description'] = this.description;
    data['Online'] = this.online;
    data['URL'] = this.uRL;
    data['created_date'] = this.createdDate;
    return data;
  }
}
