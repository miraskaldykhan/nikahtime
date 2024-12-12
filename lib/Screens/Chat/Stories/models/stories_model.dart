class MyStoryResponse {
  final List<Avatar> avatarUrl;
  final List<MyStoriesModel> data;

  MyStoryResponse({
    required this.avatarUrl,
    required this.data,
  });

  factory MyStoryResponse.fromJson(Map<String, dynamic> json) {
    var avatarList = (json['avatarUrl'] as List)
        .map((avatar) => Avatar.fromJson(avatar))
        .toList();

    var dataList = (json['data'] as List)
        .map((story) => MyStoriesModel.fromJson(story))
        .toList();

    return MyStoryResponse(
      avatarUrl: avatarList,
      data: dataList,
    );
  }
}

class MyStoriesModel {
  final int id;
  final String type;
  final String content;
  final bool? isExpired;
  final DateTime createdAt;

  MyStoriesModel({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
    this.isExpired,
  });

  // Метод для создания объекта DataItem из JSON
  factory MyStoriesModel.fromJson(Map<String, dynamic> json) {
    return MyStoriesModel(
      id: json['id'],
      type: json['type'],
      content: json['content'],
      isExpired: json['is_expired'],
      // может быть null
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Avatar {
  final String main;
  final String preview;

  Avatar({
    required this.main,
    required this.preview,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      main: json['main'],
      preview: json['preview'],
    );
  }
}
