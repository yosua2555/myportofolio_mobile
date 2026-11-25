import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

/// Portfolio education entry synchronized with the Django REST Framework API
/// (`EducationSerializer`: `id`, `institution`, `degree`, `description`,
/// `started_year`, `ended_year`, `star_count`, `is_starred`,
/// `starred_by_names`).
@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    required this.institution,
    required this.degree,
    required this.startedYear,
    this.id,
    this.description = '',
    this.endedYear,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String institution;
  final String degree;

  @JsonKey(defaultValue: '')
  final String description;

  final int startedYear;
  final int? endedYear;

  @JsonKey(defaultValue: 0, includeToJson: false)
  final int starCount;

  @JsonKey(defaultValue: false, includeToJson: false)
  final bool isStarred;

  @JsonKey(defaultValue: '', includeToJson: false)
  final String starredByNames;

  /// Returns `true` when the user is still studying (`endedYear == null`).
  bool get isCurrent => endedYear == null;

  /// Human-readable study period (`2025 - Saat ini` or `2021 - 2024`).
  String get formattedPeriod => endedYear == null
      ? '$startedYear - Saat ini'
      : '$startedYear - $endedYear';

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
