class Patient{
  String requestId, name, phone, area, address, date;
  List<double> location;

  Patient({
    required this.requestId,
    required this.name,
    required this.phone,
    required this.area,
    required this.address,
    required this.date,
    required this.location
  });

  factory Patient.fromJson(Map<String, dynamic> json){
    return Patient(
      requestId: json["request_id"],
      name: json["name"],
      phone: json["phone"],
      area: json["area"],
      address: json["address"],
      date: json["date"],
      location: <double>[json["location"][0], json["location"][1]],
    );
  }
}