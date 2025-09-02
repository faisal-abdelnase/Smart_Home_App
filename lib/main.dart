import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  MqttServerClient client = MqttServerClient.withPort('broker.hivemq.com', '1', 1883);

  MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  client.connect().then((value) => {
    if(value!.state == client.connectionStatus!.state) {

      client.subscribe("test/flutter", MqttQos.atMostOnce),

      client.publishMessage("test/flutter", MqttQos.atMostOnce, builder.addString("Hello from Flutter").payload!),

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>> c) {
        MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        log('Received message:$pt from topic: ${c[0].topic}>');
      }),

      log('Connected to MQTT broker'),

    } else {
      log('Failed to connect, status is ${value.state}')
    }
  });
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatefulWidget {
  const SmartHomeApp({super.key});

  @override
  State<SmartHomeApp> createState() => _SmartHomeAppState();
}

class _SmartHomeAppState extends State<SmartHomeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Smart Home App"),
        ),
        body: const Center(
          child: Text("Welcome to Smart Home App"),
        ),
      ),
    );
  }
}