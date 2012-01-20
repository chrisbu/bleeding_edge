
class Blob native "*Blob" {

  int get size() native "return this.size;";

  String get type() native "return this.type;";

  Blob webkitSlice([int start = null, int end = null, String contentType = null]) native;

  var dartObjectLocalStorage;

  String get typeName() native;
}
