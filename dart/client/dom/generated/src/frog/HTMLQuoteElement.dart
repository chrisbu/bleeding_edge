
class HTMLQuoteElement extends HTMLElement native "*HTMLQuoteElement" {

  String get cite() native "return this.cite;";

  void set cite(String value) native "this.cite = value;";
}
