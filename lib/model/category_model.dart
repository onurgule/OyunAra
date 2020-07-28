class CategoryModel {
  String tID;
  String name;
  Null parentId;

  CategoryModel({this.tID, this.name, this.parentId});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    tID = json['TID'];
    name = json['Name'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TID'] = this.tID;
    data['Name'] = this.name;
    data['parent_id'] = this.parentId;
    return data;
  }
}
