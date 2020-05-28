import 'dart:convert';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_sms/pip_services_sms.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('SmsHttpServiceV1', () {
    SmsHttpServiceV1 service;

    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

      var controller = SmsController();

      controller.configure(ConfigParams());

      service = SmsHttpServiceV1();
      service.configure(httpConfig);

      var references = References.fromTuples([
        Descriptor(
            'pip-services-sms', 'controller', 'default', 'default', '1.0'),
        controller,
        Descriptor('pip-services-sms', 'service', 'http', 'default', '1.0'),
        service
      ]);
      controller.setReferences(references);
      service.setReferences(references);

      await controller.open(null);
      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
    });

    test('Send message', () async {
      var message =
          SmsMessageV1(to: '+15202353563', text: 'This is a test message');
      var resp = await rest.post(url + '/v1/sms/send_message',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'message': message}));

      expect(resp, isNotNull);
      expect(resp.statusCode ~/ 100, 2);
    });
  });
}
