class SponsoringData {
  String type;
  String platform;
  String content;
  String country;
  String link;
  int duration;
  int views;
  double price;

  SponsoringData({
    required this.type,
    required this.platform,
    required this.content,
    required this.country,
    required this.link,
    required this.duration,
    required this.views,
    required this.price,
  });
}

class LocaleSponsoringData {
  String type;
  String placeName;
  String placetype;
  String firstName;
  String lastName;
  String mobileNumber;
  String country;
  String address;
  String localeType;
  String image;
  String product;
  String maker;
  double price;
  String description;
  double budget;

  LocaleSponsoringData({
    required this.type,
    required this.placeName,
    required this.placetype,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.country,
    required this.address,
    required this.localeType,
    required this.image,
    required this.product,
    required this.maker,
    required this.price,
    required this.description,
    required this.budget,
  });
}
