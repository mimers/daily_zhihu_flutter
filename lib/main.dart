import 'dart:convert';

import 'package:daily_zhihu_flutter/today_stories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DailyZhihu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: TodayScaffold(),
      ),
      onGenerateRoute: (settings) {
        if (settings.name.startsWith('/detail')) {
          var id = Uri.parse(settings.name).queryParameters['id'];
          return MaterialPageRoute(builder: (context) => StoryDetailPage(id));
        }
      },
    );
  }
}

class StoryDetailPage extends StatefulWidget {
  final id;

  StoryDetailPage(this.id);

  @override
  StoryDetailPageState createState() {
    return StoryDetailPageState();
  }
}

class StoryDetailPageState extends State<StoryDetailPage> {
  Story story;

  @override
  void initState() {
    super.initState();
    get('https://news-at.zhihu.com/api/4/news/${widget.id}').then((r) {
      setState(() {
        story = Story.fromJson(json.decode(r.body));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return story == null ? LoadingWidget() : StoryDetailWidget(story);
  }
}

class StoryDetailWidget extends StatelessWidget {
  final Story story;

  StoryDetailWidget(this.story);

  @override
  Widget build(BuildContext context) {
    var ls = ListView(
      children: <Widget>[
        Container(
          height: 220.0,
          child: Stack(fit: StackFit.expand, children: <Widget>[
            Container(
                child: Image.network(
              story.imageUrl,
              fit: BoxFit.cover,
            )),
            Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    story.title,
                    style: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ))
          ]),
        ),
        Container(
          height: 400.0,
          child: null,
        )
      ],
    );
    return InAppWebView(
      onWebViewCreated: (controller) {
        controller.loadData(story.body);
        story.css.forEach((url) => controller.injectStyleFile(url));
      },
    );
  }
}

class TodayScaffold extends StatefulWidget {
  const TodayScaffold({
    Key key,
  }) : super(key: key);

  @override
  TodayScaffoldState createState() {
    return TodayScaffoldState();
  }
}

class TodayScaffoldState extends State<TodayScaffold> {
  TodayStories stories;

  @override
  void initState() {
    super.initState();
    get("https://news-at.zhihu.com/api/4/news/latest").then((r) {
      setState(() {
        stories = TodayStories.fromJson(json.decode(r.body));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return stories == null
        ? LoadingWidget()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 240.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Text('今日消息')),
                      ),
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      background: TopStoriesWidget(stories.topStories)),
                )
              ];
            },
            body: RefreshIndicator(
              child: TodayStoriesWidget(stories.stories),
              onRefresh: () async {
                var r =
                    await get("https://news-at.zhihu.com/api/4/news/latest");
                setState(() {
                  stories = TodayStories.fromJson(json.decode(r.body));
                });
              },
            ));
  }
}

class TopStoriesWidget extends StatelessWidget {
  final List<Story> stories;

  TopStoriesWidget(this.stories);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          var story = stories[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/detail?id=${story.id}');
            },
            child: Stack(fit: StackFit.expand, children: <Widget>[
              Container(
                  child: Image.network(
                story.imageUrl,
                fit: BoxFit.cover,
              )),
              Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      story.title,
                      style: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ]),
          );
        });
  }
}

class TodayStoriesWidget extends StatelessWidget {
  final List<Story> todayStories;

  TodayStoriesWidget(this.todayStories);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: todayStories.length,
        itemBuilder: (context, index) {
          var story = todayStories[index];
          return TopStoryItemWidget(story: story);
        });
  }
}

class TopStoryItemWidget extends StatelessWidget {
  const TopStoryItemWidget({
    Key key,
    @required this.story,
  }) : super(key: key);

  final Story story;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.transparent,
      highlightColor: Colors.transparent,
      elevation: 0.0,
      highlightElevation: 0.0,
      padding: EdgeInsets.all(0.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      story.title,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.fade,
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Image.network(
                    story.imageUrl,
                    fit: BoxFit.cover,
                  ))
            ],
          ),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/detail?id=${story.id}');
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
