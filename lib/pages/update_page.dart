import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
class UpdatePage extends StatefulWidget {
  static final String id= "update_page";


  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  bool isLoading = false;
  List<Post> items = [];


  void _apiPostUpdate(Post post)async{
    Network.PUT(Network.API_UPDATE+post.id.toString(), Network.paramsUpdate(post)).then((response) => {
      LogService.i (response.toString()),
      if(response != null){
       Post.fromJson(jsonDecode(response.toString())) as List<Post>,
      }else{
        items = [],
      }
    });

  }
  void _apiPostList()async{
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      isLoading = false;
      if(response !=null){
        items= Network.parsePostList(response);
      }else{
        items =[];
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var  post = Post("acds", 1,"12cas", 1);
    _apiPostList();
    _apiPostUpdate(post);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Page"),
        backgroundColor: Colors.blue,
      ),
      body:  Stack(
        children: [
          isLoading? Center(
            child: CircularProgressIndicator(),
          ):SizedBox.shrink(),
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx,index){
              return itemOfPost(items[index]);
            },
          ),
        ],
      ),
    );
  }
  Widget itemOfPost(Post post){
    return  Container(
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title.toString().toUpperCase()),
          SizedBox(height: 5,),
          Text(post.body.toString()),
        ],
      ),
    );
  }
}
