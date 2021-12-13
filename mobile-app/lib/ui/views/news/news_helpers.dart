import 'dart:math';

import 'package:flutter/material.dart';

class NewsHelper {
  static String truncateStr(str) {
    if (str.length < 55) {
      return str;
    } else {
      return str.toString().substring(0, 55) + '...';
    }
  }

  static String getArticleImage(imgUrl, context) {
    // Split the url
    List arr = imgUrl.toString().split('images');

    // Get the last index of the arr which is the name

    if (arr.length == 1) return imgUrl;

    double screenSize = MediaQuery.of(context).size.width;
    if (screenSize >= 600) {
      imgUrl = arr[0] + 'images/size/w1000' + arr[1];
    } else if (screenSize >= 300) {
      imgUrl = arr[0] + 'images/size/w600' + arr[1];
    } else if (screenSize >= 150) {
      imgUrl = arr[0] + 'images/size/w300' + arr[1];
    } else {
      imgUrl = arr[0] + 'images/size/w100' + arr[1];
    }

    return imgUrl;
  }

  static String getProfileImage(imgUrl) {
    List arr = imgUrl.toString().split('images');

    if (arr.length == 1) return imgUrl;

    return arr[0] + 'images/size/w60' + arr[1];
  }
}
