// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayStories _$TodayStoriesFromJson(Map<String, dynamic> json) {
  return TodayStories()
    ..date = json['date'] as String
    ..stories = (json['stories'] as List)
        ?.map(
            (e) => e == null ? null : Story.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..topStories = (json['top_stories'] as List)
        ?.map(
            (e) => e == null ? null : Story.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TodayStoriesToJson(TodayStories instance) =>
    <String, dynamic>{
      'date': instance.date,
      'stories': instance.stories,
      'top_stories': instance.topStories
    };

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story()
    ..title = json['title'] as String
    ..image = json['image'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList()
    ..type = json['type'] as int
    ..id = json['id'] as int
    ..body = json['body'] as String
    ..imageSource = json['image_source'] as String
    ..shareUrl = json['share_url'] as String
    ..css = (json['css'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'title': instance.title,
      'image': instance.image,
      'images': instance.images,
      'type': instance.type,
      'id': instance.id,
      'body': instance.body,
      'image_source': instance.imageSource,
      'share_url': instance.shareUrl,
      'css': instance.css
    };
