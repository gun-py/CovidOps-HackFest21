class CommunityPost{
  String postId, personId, name, phone, area, item, details, date;
  List<double> coordinates;

  CommunityPost(
      this.postId,
      this.personId,
      this.name,
      this.phone,
      this.area,
      this.item,
      this.details,
      this.date,
      this.coordinates,
  );

  factory CommunityPost.fromJson(Map<String, dynamic> json){
    return CommunityPost(
      json["post_id"],
      json["person_id"],
      json["name"],
      json["phone"],
      json["area"],
      json["item"],
      json["details"],
      json["date"],
      <double>[json["coordinates"][0], json["coordinates"][1]]
    );
  }
}