import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../globals/globals.dart';

var uuid = Uuid();

class CocoResponse {
  final String response;
  final bool componentDone;
  final bool componentFailed;
  final Map<String, dynamic> updatedContext;
  final num confidence;
  final bool idontknow;
  final Map<String, dynamic> rawResp;

  const CocoResponse({ 
    this.response,
    this.componentDone,
    this.componentFailed,
    this.updatedContext,
    this.confidence,
    this.idontknow,
    this.rawResp });

    factory CocoResponse.fromJson(Map<String, dynamic> json) {
      if(json == null) return null;
      return CocoResponse(
        response: json['response'],
        componentDone: json['componentDone'],
        componentFailed: json['componentFailed'],
        updatedContext: json['updatedContext'],
        confidence: json['confidence'],
        idontknow: json['idontknow'],
        rawResp: json['rawResp']);
    }
}

class ComponentSession {
  final String componentId;
  String sessionId;
  final String developerKey;
  VoidCallback onSetStateClbk;

  ComponentSession(this.componentId, this.developerKey, this.onSetStateClbk) {
    sessionId = uuid.v4();
  }

  void reset() {
    sessionId = uuid.v4();
  }

  void call(String userInput){
    try {
      print("User input... ");
      Future<CocoResponse> order = requestMethod(userInput);
      order.then((CocoResponse cocoResponse) {
        newMsgFromBot=cocoResponse.response;
        onSetStateClbk();
      });
      print('Awaiting user order...');
      print(order);
    } catch (err) {
      print('Caught error: $err');
    }
  }

  Future<CocoResponse> requestMethod(String userInput) async {
        var url = 'https://app.coco.imperson.com/api/exchange/' + componentId + '/' + sessionId;
        Map<String, String> headers = {
          'Content-type' : 'application/json', 
          'Accept': 'application/json',
          'api-key': developerKey
        };

        var body = json.encode({"user_input": userInput});
        final response =
            await http.post(url, body: body, headers: headers);
        final responseJson = json.decode(response.body);
        final CocoResponse cocoResponse = CocoResponse.fromJson(responseJson);
        return cocoResponse;
    }
}

