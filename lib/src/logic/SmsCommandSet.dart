import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../data/version1/data.dart';
import 'ISmsController.dart';

class SmsCommandSet extends CommandSet {
  ISmsController _logic;

  SmsCommandSet(ISmsController logic) : super() {
    _logic = logic;

    addCommand(_makeSendMessageCommand());
    addCommand(_makeSendMessageToRecipientCommand());
    addCommand(_makeSendMessageToRecipientsCommand());
  }

  ICommand _makeSendMessageCommand() {
    return Command(
        'send_message',
        ObjectSchema(true)
            .withRequiredProperty('message', SmsMessageV1Schema())
            .withOptionalProperty('parameters', TypeCode.Map),
        (String correlationId, Parameters args) {
      var message = SmsMessageV1();
      message.fromJson(args.get('message'));
      var parameters = ConfigParams.fromValue(args.get('parameters'));
      _logic.sendMessage(correlationId, message, parameters);
    });
  }

  ICommand _makeSendMessageToRecipientCommand() {
    return Command(
        'send_message_to_recipient',
        ObjectSchema(true)
            .withRequiredProperty('message', SmsMessageV1Schema())
            .withRequiredProperty('recipient', SmsRecipientV1Schema())
            .withOptionalProperty('parameters', TypeCode.Map),
        (String correlationId, Parameters args) {
      var message = SmsMessageV1();
      message.fromJson(args.get('message'));
      var recipient = SmsRecipientV1();
      recipient.fromJson(args.get('recipient'));
      var parameters = ConfigParams.fromValue(args.get('parameters'));

      _logic.sendMessageToRecipient(
          correlationId, recipient, message, parameters);
    });
  }

  ICommand _makeSendMessageToRecipientsCommand() {
    return Command(
        'send_message_to_recipients',
        ObjectSchema(true)
            .withRequiredProperty('message', SmsMessageV1Schema())
            .withRequiredProperty(
                'recipients', ArraySchema(SmsRecipientV1Schema()))
            .withOptionalProperty('parameters', TypeCode.Map),
        (String correlationId, Parameters args) {
      var message = SmsMessageV1();
      message.fromJson(args.get('message'));
      //var recipients = args.get("recipients");
      var recipients = List<SmsRecipientV1>.from(args
          .get('recipients')
          .map((itemsJson) => SmsRecipientV1.fromJson(itemsJson)));
      var parameters = ConfigParams.fromValue(args.get('parameters'));
      _logic.sendMessageToRecipients(
          correlationId, recipients, message, parameters);
    });
  }
}
