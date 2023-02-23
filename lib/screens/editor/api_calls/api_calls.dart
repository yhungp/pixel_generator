import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

postVideo(String video) async {
  try {
    final response = await Dio().post(
      'http://127.0.0.1:5000/set_video',
      data: jsonEncode(
        {'video': video},
      ),
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );

    return {
      "success": response.data["success"],
      "code": response.statusCode,
      "fps": response.data["fps"],
    };
  } catch (e) {
    return {
      "success": false,
      "code": 400,
      "fps": 30,
    };
  }
}

getFrame() async {
  try {
    final response = await Dio().get(
      'http://localhost:5000/get_current_frame',
    );

    List bytes = jsonDecode(response.data)["bytes"];
    List<int> bytesInt = List.generate(
      bytes.length,
      (index) => int.parse(bytes[index].toString()),
    );

    return {
      'bytes': bytesInt,
      'frame_counter': jsonDecode(response.data)["frame_counter"],
      "code": response.statusCode,
    };
  } catch (_) {
    return {
      'bytes': List.generate(0, (index) => 0),
      'frame_counter': 0,
      "code": 400,
    };
  }
}

setPlayPause(bool playPause) async {
  try {
    final response = await Dio().post(
      'http://127.0.0.1:5000/play_pause',
      data: jsonEncode(
        {'play_pause': playPause},
      ),
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );

    return {
      'success': response.data["success"],
      'play_pause': response.data["play_pause"],
    };
  } catch (e) {
    return {
      'success': false,
      'play_pause': false,
    };
  }
}
