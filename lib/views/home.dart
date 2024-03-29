import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fnews_app/helper/data.dart';
import 'package:fnews_app/helper/news.dart';
import 'package:fnews_app/models/article_model.dart';
import 'package:fnews_app/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'article_view.dart';
import 'category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading =  true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  void getNews() async {
    News newsClass = News();
    await newsClass.getNews();
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
        centerTitle: true,backgroundColor: Colors.cyan,
      ),
      body: _loading
          ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) : SingleChildScrollView(
        child: Container(
//          margin: EdgeInsets.only(top: 5),
          child: Column(
            children: <Widget>[
              // Categories
              Container(decoration: BoxDecoration(color: Color(0xFFcbfef6)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                height: 65,
                child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoryTile(
                        imageUrl: categories[index].imageUrl,
                        categoryName: categories[index].categoryName,
                      );
                    }),
              ),

              //Blogs
              Container(decoration: BoxDecoration(color: Colors.black87),
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

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryNews(
            category: categoryName.toString().toLowerCase(),
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl: imageUrl,
                  width: 120, height: 60, fit: BoxFit.cover),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            )
          ],
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
        margin: EdgeInsets.only(bottom: 16),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                  child: Image.network(imageUrl)),
              SizedBox(height: 10),
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
