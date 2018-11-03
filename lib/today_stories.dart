import 'package:json_annotation/json_annotation.dart';

part 'today_stories.g.dart';

@JsonSerializable()
class TodayStories {
  TodayStories() {}
  @JsonKey(name: 'date')
  String date;
  @JsonKey(name: 'stories')
  List<Story> stories;
  @JsonKey(name: 'top_stories')
  List<Story> topStories;

  factory TodayStories.fromJson(Map<String, dynamic> json) =>
      _$TodayStoriesFromJson(json);

  Map<String, dynamic> toJson() => _$TodayStoriesToJson(this);
}

@JsonSerializable()
class Story {
  Story() {}
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'image')
  String image;
  @JsonKey(name: 'images')
  List<String> images;
  @JsonKey(name: 'type')
  int type;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'body')
  String body;
  @JsonKey(name: 'image_source')
  String imageSource;
  @JsonKey(name: 'share_url')
  String shareUrl;
  @JsonKey(name: 'css')
  List<String> css;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);

  String get imageUrl {
    if (image != null) {
      return image;
    } else if (images != null && images.length > 0) {
      return images[0];
    } else {
      return null;
    }
  }
}
