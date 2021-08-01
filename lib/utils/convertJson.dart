import 'dart:convert';

import 'package:flutterassignment/model/core/countryMode.dart';


convertJsonToCountryModelList(String arrayObjsText) {
  var tagObjsJson = jsonDecode(arrayObjsText) as List;
  List<Country> tagObjs =
      tagObjsJson.map((tagJson) => Country.fromJson(tagJson)).toList();

  print('trying $tagObjs');
  return tagObjs;
}