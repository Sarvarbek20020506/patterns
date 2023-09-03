class Post{
  int? id;
  String? title;
  String? body;
  int? userId;

  Post(this.body,this.id,this.title,this.userId);

  Post.fromJson(Map<String,dynamic> json):
      userId = json["userId"],
      title = json["title"],
      id=json["id"],
      body = json["body"];

  Map<String,dynamic> toJson()=>{
    "id" : id,
    "title":title,
    "body":body,
    "userId":userId,
  };
}