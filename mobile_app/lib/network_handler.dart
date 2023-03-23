// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkHandler {
  final String baseUrl = 'https://sheltered-stream-81011.herokuapp.com/api';
  var log = Logger();

  String formateur(String url) {
    return baseUrl + url;
  }

  Future<http.Response> get(String url) async {
    url = formateur(url);
    var response = await http.get(
      Uri.parse(url),
    );
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formateur(url);
    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      body: body,
    );
    log.i(response.body);
    log.i(response.statusCode);
    return response;
  }
  
  LaunchmyUrl(String url) async {
    Uri _url = Uri.parse(url);
    var launchUrl2 = launchUrl(_url,
       webOnlyWindowName: "_blank", mode: LaunchMode.externalApplication);
    if (!await launchUrl2) {
      throw Exception('Could not launch $_url');
    }
  }
}
