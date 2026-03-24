class CreateEventoResponseDto {
  final String id;
  final String message;

  const CreateEventoResponseDto({required this.id, required this.message});

  factory CreateEventoResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateEventoResponseDto(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
