import 'package:flutter/material.dart';
import 'package:fnews_app/helper/news.dart';
import 'package:fnews_app/models/article_model.dart';

import 'article_view.dart';

class CategoryNews extends StatefulWidget {

  final String category;
  CategoryNews({this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {

  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    getCategoryNews();
  }

  void getCategoryNews() async{
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "News",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor: Colors.cyan,
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(padding:EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.save)),
          )
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body:  _loading
          ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) :  SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(decoration: BoxDecoration(color: Colors.black87,),
                child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return BlogTile(
                          imageUrl: articles[index].urlToImage,
                          title: articles[index].title,
                          desc: articles[index].description,
                          url: articles[index].url);
                    }),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile(
      {@required this.imageUrl, @required this.title, @required this.desc, @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>ArticleView(
              blogUrl: url,
            )
        ),);
      },
      child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(6)),
          margin: EdgeInsets.only(bottom: 14),
          child: Column(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(imageUrl)),
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.only(right:3.0, left: 3, top: 3),
                child: Text(title, style: TextStyle(
                    fontSize: 19,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600
                ),),
              ),
              SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.only(right:3.0, left: 3, bottom: 3),
                child: Text(desc, style: TextStyle(
                    color: Colors.black54
                ),),
              ),
            ],
          )),
    );
  }
}
