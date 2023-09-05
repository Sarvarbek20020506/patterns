import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart';
import 'package:patterns/pages/create_page.dart';
import 'package:patterns/pages/update_page.dart';

import '../models/post_model.dart';
import '../services/http_service.dart';
class HomePage extends StatefulWidget {
  static final String id = "home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];



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

void _apiPostDelete(Post post)async{
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(Network.API_DEL+post.id.toString(), Network.paramsEmpty());
    setState(() {
      if(response != null){
        _apiPostList();
      }else{
        items= [];
      }
        isLoading = false;
    });
}


  @override
  void initState() {
    super.initState();
    _apiPostList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("setState"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.pushReplacementNamed(context, CreatePage.id);
          },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        child: const Icon(Icons.add,color: Colors.black,),
      ),
    );
  }

  Widget itemOfPost(Post post){
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: (){
            Navigator.pushReplacementNamed(context, UpdatePage.id);
          },
        ),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: "Update",
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: (){
            _apiPostDelete(post as Post);
          },
        ),
        children: [
          SlidableAction(onPressed: (BuildContext context){
            _apiPostDelete(post);
          },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: "Delete",
          ),
        ],
      ),
      child: Container(
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
      ),
    );
  }
}
