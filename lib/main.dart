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

      log('Connected to MQTT broker'),
      
    } else {
      log('Failed to connect, status is ${value.state}')
    }
  });
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}