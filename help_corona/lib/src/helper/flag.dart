class setCountryFlag {
  static List<countryFlag> flags = [];

}

class countryFlag {
  String shareUrl = "https://www.countryflags.io/";
  String countryCode;
  String restUrl = "/flat/64.png";
  String result;

  countryFlag(
    {this.countryCode}
  );
  
  String makeUrl() {
    result = shareUrl + countryCode + restUrl;
    return result;
  }
}