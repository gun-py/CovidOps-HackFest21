class Provider{
  String providerId, name, phone, area;
  List<double> coordinates;

  Provider({
    required this.providerId,
    required this.name,
    required this.phone,
    required this.area,
    required this.coordinates
  });

  factory Provider.fromJson(Map<String, dynamic> json){
    return Provider(
      providerId: json["provider_id"],
      name: json["name"],
      phone: json["phone"],
      area: json["area"],
      coordinates: [json["coordinates"][0], json["coordinates"][1]],
    );
  }
}