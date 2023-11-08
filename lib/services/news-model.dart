class NewsModel{
  String? heading;
  String? desc;
  String? imgUrl;
  String? newsUrl;

  NewsModel({this.heading, this.desc, this.imgUrl, this.newsUrl});


  factory NewsModel.fromMap(Map news){
    return NewsModel(
      heading: news["title"],
      desc: news["description"],
      imgUrl: news["urlToImage"],
      newsUrl: news["url"],
    );
  }
}