class Users {
  int score;
  Restaurant restaurant;
  bool isPlay;
  String userName;
  String id;

  Users({this.score, this.restaurant, this.isPlay, this.userName, this.id});
}

class Restaurant {
  int restaurantRate;
  String restaurantAddress;
  String restaurantName;
  String restaurantImg;
  String restaurantId;

  Restaurant(
      {this.restaurantRate,
      this.restaurantAddress,
      this.restaurantName,
      this.restaurantImg,
      this.restaurantId});
}
