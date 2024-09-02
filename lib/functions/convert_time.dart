Future<String> convertTime(String time) async {
  String result = '';

  List<String> timeSplit = time.split(':');

  for (var i = 0; i < timeSplit.length; i++) {
    String e = timeSplit[i];
    if (e.length == 1 && i != 2) {
      result = "${result}0${e.toString()}:";
    } else if (i != 2) {
      result = "$result${e.toString()}:";
    } else {
      result = "$result${e.toString()}";
    }
  }

  return result;
}
