class MyRequestModel {
  String id = "A",
      essential = "rem",
      date = "A";
  String provider_name = "A",
      provider_phone = "A",
      provider_id = "A";
  bool sought_approval = false,
      approved = false;


  MyRequestModel({
    required this.id,
    required this.essential,
    required this.date,
    required this.provider_name,
    required this.provider_phone,
    required this.provider_id,
    required this.sought_approval,
    required this.approved,
  });

  factory MyRequestModel.fromJson(Map<String, dynamic> json){
    return MyRequestModel(
        id: json["id"],
        essential: json["essential"],
        date: json["date"],
        provider_name: json["provider_name"],
        provider_phone: json["provider_phone"],
        provider_id: json["provider_id"],
        sought_approval: json["sought_approval"],
        approved: json["approved"],
    );
  }
}
