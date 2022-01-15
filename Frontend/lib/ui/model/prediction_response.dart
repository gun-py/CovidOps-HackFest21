class PredictionResponse{
  int status;
  String prediction;

  PredictionResponse({required this.status, required this.prediction});

  factory PredictionResponse.fromJson(Map<String, dynamic> json){
    return PredictionResponse(
      status: json["status"],
      prediction: json["prediction"],
    );
  }
}