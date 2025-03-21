// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      count: (json['count'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      lastPage: (json['lastPage'] as num).toInt(),
      from: (json['from'] as num?)?.toInt(),
      to: (json['to'] as num?)?.toInt(),
      nextPageUrl: json['nextPageUrl'] as String?,
      prevPageUrl: json['prevPageUrl'] as String?,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'count': instance.count,
      'perPage': instance.perPage,
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'from': instance.from,
      'to': instance.to,
      'nextPageUrl': instance.nextPageUrl,
      'prevPageUrl': instance.prevPageUrl,
    };
