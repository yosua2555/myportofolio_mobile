import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Portfolio project synchronized with the Django REST Framework API
/// (`ProjectSerializer`: `id`, `name`, `description`, `date`, `star_count`,
/// `is_starred`, `starred_by_names`).
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.name,
    required this.description,
    required this.date,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
    this.projectImageUrl = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String name;
  final String description;
  final int date;

  @JsonKey(defaultValue: 0, includeToJson: false)
  final int starCount;

  @JsonKey(defaultValue: false, includeToJson: false)
  final bool isStarred;

  @JsonKey(defaultValue: '', includeToJson: false)
  final String starredByNames;

  @JsonKey(defaultValue: '', includeToJson: false)
  final String projectImageUrl;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
