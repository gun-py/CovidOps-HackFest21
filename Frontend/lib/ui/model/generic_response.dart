class GenericResponse{
  int code;
  String message;

  GenericResponse({required this.code, required this.message});

  factory GenericResponse.fromJson(Map<String, dynamic> json){
    return GenericResponse(
      code: json["code"],
      message: json["message"],
    );
  }
}