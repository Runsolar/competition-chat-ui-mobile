import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../globals/globals.dart';

var uuid = Uuid();

class DialogFlowResponse {
  final String speech;
  final List<Map<String, dynamic>> messages;

  const DialogFlowResponse({ 
    this.speech,
    this.messages });

    factory DialogFlowResponse.fromJson(Map<String, dynamic> json) {
      if(json == null) return null;
      return DialogFlowResponse(
        speech: json['speech'],
        messages: json['messages']);
    }
}

class ComponentDialogFlowSession {
  final String componentId;
  String sessionId;
  final String developerKey;
  VoidCallback onSetStateClbk;

  ComponentDialogFlowSession(this.componentId, this.developerKey, this.onSetStateClbk) {
    sessionId = uuid.v4();
  }

  void reset() {
    sessionId = uuid.v4();
  }

  void call(String userInput){
    try {
      print("User input... ");
      Future<DialogFlowResponse> order = requestMethod(userInput);
      order.then((DialogFlowResponse dialogFlowResponseResponse) {
        newMsgFromBot = dialogFlowResponseResponse.speech;
        onSetStateClbk();
      });
      print('Awaiting user order...');
      print(order);
    } catch (err) {
      print('Caught error: $err');
    }
  }

  Future<DialogFlowResponse> requestMethod(String userInput) async {
        var url = 'https://api.dialogflow.com/v1/query?v=20150910' + componentId + '/' + sessionId;
        Map<String, String> headers = {
          'Content-type' : 'application/json', 
          'Accept': 'application/json',
          'Bearer ': developerKey
        };

        var body = json.encode({"lang": "en" , "sessionId" : this.sessionId, "query" : userInput});
        final response =
            await http.post(url, body: body, headers: headers);
        final responseJson = json.decode(response.body);
        final DialogFlowResponse cocoResponse = DialogFlowResponse.fromJson(responseJson['result']['fulfillment']);
        return cocoResponse;
    }
}