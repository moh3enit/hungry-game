class InfoRestaurant {
  List<Businesses> _businesses;
  int _total;

  List<Businesses> get businesses => _businesses;
  int get total => _total;

  InfoRestaurant({
      List<Businesses> businesses, 
      int total}){
    _businesses = businesses;
    _total = total;
}

  InfoRestaurant.fromJson(dynamic json) {
    if (json["businesses"] != null) {
      _businesses = [];
      json["businesses"].forEach((v) {
        _businesses.add(Businesses.fromJson(v));
      });
    }
    _total = json["total"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_businesses != null) {
      map["businesses"] = _businesses.map((v) => v.toJson()).toList();
    }
    map["total"] = _total;
    return map;
  }

}

/// id : "9Hp8kwNv9Ks8wkU5AxZUhA"
/// alias : "chicos-pizza-san-francisco"
/// name : "Chico's Pizza"
/// image_url : "https://s3-media1.fl.yelpcdn.com/bphoto/EORjLLcfSZ-YJPH5ezc4Vw/o.jpg"
/// is_closed : false
/// url : "https://www.yelp.com/biz/chicos-pizza-san-francisco?adjust_creative=6WsAIOGfyLKXDe7CdeDpMA&utm_campaign=yelp_api_v3&utm_medium=api_v3_transactions_search_delivery&utm_source=6WsAIOGfyLKXDe7CdeDpMA"
/// review_count : 360
/// categories : [{"alias":"pizza","title":"Pizza"}]
/// rating : 3.5
/// coordinates : {"latitude":37.7807693,"longitude":-122.4081793}
/// transactions : ["pickup","delivery"]
/// price : "$"
/// location : {"address1":"131 6th St","address2":"","address3":"","city":"San Francisco","zip_code":"94103","country":"US","state":"CA","display_address":["131 6th St","San Francisco, CA 94103"]}
/// phone : "+14152551111"
/// display_phone : "(415) 255-1111"

class Businesses {
  String _id;
  String _alias;
  String _name;
  String _imageUrl;
  bool _isClosed;
  String _url;
  int _reviewCount;
  List<Categories> _categories;
  double _rating;
  Coordinates _coordinates;
  List<String> _transactions;
  String _price;
  Location _location;
  String _phone;
  String _displayPhone;

  String get id => _id;
  String get alias => _alias;
  String get name => _name;
  String get imageUrl => _imageUrl;
  bool get isClosed => _isClosed;
  String get url => _url;
  int get reviewCount => _reviewCount;
  List<Categories> get categories => _categories;
  double get rating => _rating;
  Coordinates get coordinates => _coordinates;
  List<String> get transactions => _transactions;
  String get price => _price;
  Location get location => _location;
  String get phone => _phone;
  String get displayPhone => _displayPhone;

  Businesses({
      String id, 
      String alias, 
      String name, 
      String imageUrl, 
      bool isClosed, 
      String url, 
      int reviewCount, 
      List<Categories> categories, 
      double rating, 
      Coordinates coordinates, 
      List<String> transactions, 
      String price, 
      Location location, 
      String phone, 
      String displayPhone}){
    _id = id;
    _alias = alias;
    _name = name;
    _imageUrl = imageUrl;
    _isClosed = isClosed;
    _url = url;
    _reviewCount = reviewCount;
    _categories = categories;
    _rating = rating;
    _coordinates = coordinates;
    _transactions = transactions;
    _price = price;
    _location = location;
    _phone = phone;
    _displayPhone = displayPhone;
}

  Businesses.fromJson(dynamic json) {
    _id = json["id"];
    _alias = json["alias"];
    _name = json["name"];
    _imageUrl = json["image_url"];
    _isClosed = json["is_closed"];
    _url = json["url"];
    _reviewCount = json["review_count"];
    if (json["categories"] != null) {
      _categories = [];
      json["categories"].forEach((v) {
        _categories.add(Categories.fromJson(v));
      });
    }
    _rating = json["rating"];
    _coordinates = json["coordinates"] != null ? Coordinates.fromJson(json["coordinates"]) : null;
    _transactions = json["transactions"] != null ? json["transactions"].cast<String>() : [];
    _price = json["price"];
    _location = json["location"] != null ? Location.fromJson(json["location"]) : null;
    _phone = json["phone"];
    _displayPhone = json["display_phone"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["alias"] = _alias;
    map["name"] = _name;
    map["image_url"] = _imageUrl;
    map["is_closed"] = _isClosed;
    map["url"] = _url;
    map["review_count"] = _reviewCount;
    if (_categories != null) {
      map["categories"] = _categories.map((v) => v.toJson()).toList();
    }
    map["rating"] = _rating;
    if (_coordinates != null) {
      map["coordinates"] = _coordinates.toJson();
    }
    map["transactions"] = _transactions;
    map["price"] = _price;
    if (_location != null) {
      map["location"] = _location.toJson();
    }
    map["phone"] = _phone;
    map["display_phone"] = _displayPhone;
    return map;
  }

}

/// address1 : "131 6th St"
/// address2 : ""
/// address3 : ""
/// city : "San Francisco"
/// zip_code : "94103"
/// country : "US"
/// state : "CA"
/// display_address : ["131 6th St","San Francisco, CA 94103"]

class Location {
  String _address1;
  String _address2;
  String _address3;
  String _city;
  String _zipCode;
  String _country;
  String _state;
  List<String> _displayAddress;

  String get address1 => _address1;
  String get address2 => _address2;
  String get address3 => _address3;
  String get city => _city;
  String get zipCode => _zipCode;
  String get country => _country;
  String get state => _state;
  List<String> get displayAddress => _displayAddress;

  Location({
      String address1, 
      String address2, 
      String address3, 
      String city, 
      String zipCode, 
      String country, 
      String state, 
      List<String> displayAddress}){
    _address1 = address1;
    _address2 = address2;
    _address3 = address3;
    _city = city;
    _zipCode = zipCode;
    _country = country;
    _state = state;
    _displayAddress = displayAddress;
}

  Location.fromJson(dynamic json) {
    _address1 = json["address1"];
    _address2 = json["address2"];
    _address3 = json["address3"];
    _city = json["city"];
    _zipCode = json["zip_code"];
    _country = json["country"];
    _state = json["state"];
    _displayAddress = json["display_address"] != null ? json["display_address"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["address1"] = _address1;
    map["address2"] = _address2;
    map["address3"] = _address3;
    map["city"] = _city;
    map["zip_code"] = _zipCode;
    map["country"] = _country;
    map["state"] = _state;
    map["display_address"] = _displayAddress;
    return map;
  }

}

/// latitude : 37.7807693
/// longitude : -122.4081793

class Coordinates {
  double _latitude;
  double _longitude;

  double get latitude => _latitude;
  double get longitude => _longitude;

  Coordinates({
      double latitude, 
      double longitude}){
    _latitude = latitude;
    _longitude = longitude;
}

  Coordinates.fromJson(dynamic json) {
    _latitude = json["latitude"];
    _longitude = json["longitude"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    return map;
  }

}

/// alias : "pizza"
/// title : "Pizza"

class Categories {
  String _alias;
  String _title;

  String get alias => _alias;
  String get title => _title;

  Categories({
      String alias, 
      String title}){
    _alias = alias;
    _title = title;
}

  Categories.fromJson(dynamic json) {
    _alias = json["alias"];
    _title = json["title"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["alias"] = _alias;
    map["title"] = _title;
    return map;
  }

}