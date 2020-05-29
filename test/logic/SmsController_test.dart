import 'dart:io';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_sms/pip_services_sms.dart';
import 'package:test/test.dart';

void main() {
  group('SmsController', () {
    SmsController controller;

    var awsAccessId = Platform.environment['AWS_ACCESS_ID'];
    var awsAccessKey = Platform.environment['AWS_ACCESS_KEY'];

    var messageFrom = Platform.environment['MESSAGE_FROM'] ?? 'PipDevs';
    var messageTo = Platform.environment['MESSAGE_TO'] ?? '+380509590743';

    setUp(() async {
      controller = SmsController();

      var config = ConfigParams.fromTuples([
        'message.from',
        messageFrom,
        'credential.access_id',
        awsAccessId,
        'credential.access_key',
        awsAccessKey
      ]);
      controller.configure(config);

      await controller.open(null);
    });

    tearDown(() async {
      await controller.close(null);
    });

    test('Send Message to Address', () async {
      var message = SmsMessageV1(to: messageTo, text: '{{text}}');
      var parameters = ConfigParams.fromTuples(['text', 'This is just a test']);

      await controller.sendMessage(null, message, parameters);
    });

    test('Send Message to Recipient', () async {
      var message = SmsMessageV1(text: 'This is just a test');
      var recipient =
          SmsRecipientV1(id: '1', phone: messageTo, name: 'Test Recipient');

      await controller.sendMessageToRecipient(null, recipient, message, null);
    });
  });
}
