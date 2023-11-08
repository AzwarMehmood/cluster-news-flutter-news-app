import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../services/news-model.dart';
import 'news-page.dart';

class SearchScreen extends StatefulWidget {
  String callQuery;
  SearchScreen(this.callQuery);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  List<NewsModel> newsList = <NewsModel>[];
  List<String> navBarItem = [
    "International",
    "Today",
    "Weather",
    "Politics",
    "Economy",
    "Health",
    "Sports"
  ];

  bool isLoading = true;
  bool isLoadingHeadlines = true;

  @override
  void initState() {
    // TODO: implement initState
    getNews(widget.callQuery);
    super.initState();
  }

  getNews(String query) async {
    Response response = await get(Uri.parse(
        "http://newsapi.org/v2/everything?q=$query&sortBy=popularity&apiKey=63f5555fe4054d858fe479c0f399a6db"));
    Map newsData = jsonDecode(response.body);

    // newsList = newsData["articles"].forEach((element){
    //   NewsModel.fromMap(element);
    // }).toList();

    newsData["articles"].forEach((element) {
      NewsModel newsModel =
          new NewsModel(heading: "", desc: "", imgUrl: "", newsUrl: "");
      newsModel = NewsModel.fromMap(element);
      if ((newsModel.heading!.isNotEmpty && newsModel.heading != null) &&
          (newsModel.desc!.isNotEmpty && newsModel.desc != null) &&
          (newsModel.imgUrl!.isNotEmpty && newsModel.imgUrl != null) &&
          (newsModel.newsUrl!.isNotEmpty && newsModel.newsUrl != null)) {
        newsList.add(newsModel);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cluster News",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffB80000),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 75,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListView.builder(
                  itemCount: navBarItem.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchScreen(navBarItem[index])));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffB80000),
                          foregroundColor: Colors.black,
                        ),
                        child: Center(
                            child: Text(
                          navBarItem[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        )),
                      ),
                    );
                  }),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      widget.callQuery,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: newsList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage(newsList[index].newsUrl)));
                                },
                                child: Card(
                                  surfaceTintColor: Colors.black,
                                  elevation: 10,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          newsList[index].imgUrl.toString(),
                                          height: 220,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                            height: 90,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8)),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                )),
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15, top: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  newsList[index]
                                                      .heading
                                                      .toString(),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  newsList[index].desc.toString(),
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
