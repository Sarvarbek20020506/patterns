import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/post_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';
class CreatePage extends StatefulWidget {
  static final String id ="create_page";
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {

  bool isLoading = false;
  List<Post> items = [];




  void _apiPostCreate() async {
    try {
      final response = await Network.POST(Network.API_CREATE, Network.paramsCreate(post as Post ));

      if (response != null) {
        LogService.w(response);
        Post.fromJson(jsonDecode(response.toString())) as List<Post>;
        LogService.d("ishladi");
      } else {
        LogService.e("api ishlamadi");
      }
    } catch (e) {
      LogService.e("Xatolik: $e");
    }
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
    //var  post = Post("acds", 1,"12cas", 1);
    _apiPostList();
    _apiPostCreate();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Page"),
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
          SizedBox(height: 5,),
          Text(post.id.toString()),
          Text(post.body.toString()),
        ],
      ),
    );
  }
}

