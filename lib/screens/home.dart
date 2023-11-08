import 'dart:convert';
import 'package:cluster_news/screens/news-page.dart';
import 'package:cluster_news/screens/search-screen.dart';
import 'package:cluster_news/services/news-model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsModel> newsList = <NewsModel>[];
  List<NewsModel> newsHeadlinesList = <NewsModel>[];
  bool isLoading = true;
  bool isLoadingHeadlines = true;

  List<String> navBarItem = [
    "International",
    "Today",
    "Weather",
    "Politics",
    "Economy",
    "Health",
    "Sports"
  ];

  @override
  void initState() {
    // TODO: implement initState
    getNews("politics");
    getNewsHeadlines("business");
    super.initState();
  }

  getNews(String query) async {
    Response response = await get(Uri.parse(
        "http://newsapi.org/v2/everything?q=$query&sortBy=popularity&apiKey=63f5555fe4054d858fe479c0f399a6db"));
    Map newsData = jsonDecode(response.body);

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

  getNewsHeadlines(String query) async {
    Response response = await get(Uri.parse(
        "http://newsapi.org/v2/everything?q=$query&sortBy=popularity&apiKey=63f5555fe4054d858fe479c0f399a6db"));
    Map newsData = jsonDecode(response.body);

    newsData["articles"].forEach((element) {
      NewsModel newsModel =
          new NewsModel(heading: "", desc: "", imgUrl: "", newsUrl: "");
      newsModel = NewsModel.fromMap(element);
      if ((newsModel.heading!.isNotEmpty && newsModel.heading != null) &&
          (newsModel.desc!.isNotEmpty && newsModel.desc != null) &&
          (newsModel.imgUrl!.isNotEmpty && newsModel.imgUrl != null) &&
          (newsModel.newsUrl!.isNotEmpty && newsModel.newsUrl != null)) {
        newsHeadlinesList.add(newsModel);
      }
    });

    setState(() {
      isLoadingHeadlines = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                        child: Text(
                      "Cluster News",
                      style: TextStyle(color: Colors.white),
                    )),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    icon: Icon(Icons.refresh))
              ],
            )
          ],
        ),
        backgroundColor: Color(0xffB80000),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        // title: Text(
        //   "Cluster News",
        //   style: TextStyle(color: Colors.white),
        // ),
        // centerTitle: true,
        // backgroundColor: Color(0xffB80000),
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
                          Navigator.push(
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
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: isLoadingHeadlines
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : CarouselSlider(
                      items: newsHeadlinesList.map((element) {
                        return Builder(builder: (BuildContext context) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage(element.newsUrl.toString())));
                            },
                            child: Card(
                              surfaceTintColor: Colors.black,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      element.imgUrl.toString(),
                                      fit: BoxFit.cover,
                                      height: 200,
                                    ),
                                  ),
                                  Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(8),
                                                bottomLeft: Radius.circular(8)),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            )),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: Text(
                                          element.heading.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                      }).toList(),
                      options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5, top: 10),
                    child: Text(
                      "TODAY'S NEWS",
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
