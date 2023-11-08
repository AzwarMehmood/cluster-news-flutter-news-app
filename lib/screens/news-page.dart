import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatefulWidget {
  String? newsUrl;
  NewsPage(this.newsUrl);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late String newNewsUrl;
  final Completer<WebViewController> controller = new Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.newsUrl.toString().contains("http://")){
      newNewsUrl = widget.newsUrl.toString().replaceAll("http://", "https://");
    }
    else{
      newNewsUrl = widget.newsUrl.toString();
    }
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
      body: Container(
          child: WebView(
            initialUrl: newNewsUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController){
              setState(() {
                controller.complete(webViewController);
              });
            },
          )),
    );
  }
}
