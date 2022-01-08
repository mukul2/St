class TenantProjects {
 late String projectNumber;
 late String projectId;
 late String lifecycleState;
 late String name;
 late String createTime;
 late Parent parent;

  TenantProjects(
      { required this.projectNumber,
        required  this.projectId,
        required  this.lifecycleState,
        required  this.name,
        required  this.createTime,
        required  this.parent});

  TenantProjects.fromJson(Map<String, dynamic> json) {
    projectNumber = json['projectNumber'];
    projectId = json['projectId'];
    lifecycleState = json['lifecycleState'];
    name = json['name'];
    createTime = json['createTime'];
    parent =
    (json['parent'] != null ? new Parent.fromJson(json['parent']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectNumber'] = this.projectNumber;
    data['projectId'] = this.projectId;
    data['lifecycleState'] = this.lifecycleState;
    data['name'] = this.name;
    data['createTime'] = this.createTime;
    if (this.parent != null) {
      data['parent'] = this.parent.toJson();
    }
    return data;
  }
}

class Parent {
  late String type;
  late String id;

  Parent({required this.type, required this.id});

  Parent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}