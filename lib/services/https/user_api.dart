import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../models/user/user_list_results.dart';

class UserApiClient {
  final HttpClient _httpClient = HttpClient();

  Future<UserListResult> getList(int start, int size) async {
    final url = 'https://randomuser.me/api/?gender=female&page=$start&results=$size';
    final request = await _httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      String rawResponse = await response.transform(utf8.decoder).join();
      Map<String, dynamic> json = JsonCodec().decode(rawResponse);
      return UserListResult.fromJson(json);
    } else {
      throw Exception();
    }
  }
}
