import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:uuid/uuid.dart';
import '../globals/globals.dart';

var uuid = Uuid();

class Messages {
  String lang;
  int type;
  String speech;
  Messages({this.lang, this.type, this.speech});
}

class Metadata {
  final String intentId;
  final String intentName;
  final String webhookUsed;
  final String webhookForSlotFillingUsed;
  final String isFallbackIntent;

  const Metadata(
    this.intentId,
    this.intentName,
    this.webhookUsed,
    this.webhookForSlotFillingUsed,
    this.isFallbackIntent
  );
}

class Fulfillment {
  final String speech;
  final List<Messages> messages;

  const Fulfillment(
    this.speech,
    this.messages
  );
}


class Result {
 final String source;
 final String resolvedQuery;
 final String action;
 final bool actionIncomplete;
 final Float score;
 final Map<String, String> parametrs;
 final List<dynamic> context;
 final Map<String, String> metadata;
 final Map<String, dynamic> fulfilment;

 const Result(
    this.source,
    this.resolvedQuery,
    this.action,
    this.actionIncomplete,
    this.score,
    this.parametrs,
    this.context,
    this.metadata,
    this.fulfilment
 );

}

class DialogFlowResponse {
  final String id;
  final String lang;
  final String sessionId;
  final String timestamp;
  final Map<String, dynamic> result;
  final Map<String, dynamic> status;
  //final String speech;
  //final List<Messages> messages;

  const DialogFlowResponse({ 
    //this.speech,
    //this.messages 
      this.id,
      this.lang,
      this.sessionId,
      this.timestamp,
      this.result,
      this.status
    });

    factory DialogFlowResponse.fromJson(Map<String, dynamic> json) {
      if(json == null) return null;
      return DialogFlowResponse(
        id: json['id'] as String,
        lang: json['lang'] as String,
        sessionId: json['sessionId'] as String,
        timestamp: json['timestamp'] as String,
        result: json['result'] as Map<String, dynamic>,
        status: json['status'] as Map<String, dynamic>
      );
    }
}

class ComponentDialogFlowSession {
  final String componentId;
  String sessionId;
  final String developerKey;

  ComponentDialogFlowSession(this.componentId, this.developerKey) {
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
        print(dialogFlowResponseResponse.result['fulfillment']['speech']);
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
          'Authorization': 'Bearer ' + developerKey
        };

        var body = json.encode({"lang": "en" , "sessionId" : this.sessionId, "query" : userInput});
        final response =
            await http.post(url, body: body, headers: headers);
        final responseJson = json.decode(response.body);
        //print(responseJson);
        final DialogFlowResponse cocoResponse = DialogFlowResponse.fromJson(responseJson);
        return cocoResponse;
    }
}
