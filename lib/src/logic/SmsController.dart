import 'dart:async';
import 'dart:typed_data';
import 'package:aws_sns_api/sns-2010-03-31.dart';
import 'package:shared_aws_api/shared.dart' as _s;
import 'package:mustache4dart2/mustache4dart2.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services_sms/src/data/version1/data.dart';

import './SmsCommandSet.dart';
import './ISmsController.dart';

class SmsController
    implements
        IConfigurable,
        IReferenceable,
        ICommandable,
        IOpenable,
        ISmsController {
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples([
    'message.from',
    null,
    'options.connect_timeout',
    30000,
    'options.max_price',
    0.5,
    'options.sms_type',
    'Promotional'
  ]);

  final CredentialResolver _credentialResolver = CredentialResolver();
  final CompositeLogger _logger = CompositeLogger();

  SNS sns;
  bool _opened = false;
  CredentialParams _credential;

  ConfigParams config;
  String _messageFrom;
  ConfigParams _parameters = ConfigParams();

  final bool _disabled = false;
  num _connectTimeout = 30000;
  num _maxPrice = 0.5;
  String _smsType = 'Transactional';

  SmsCommandSet _commandSet;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    config = config.setDefaults(SmsController._defaultConfig);

    _messageFrom = config.getAsStringWithDefault('message.from', _messageFrom);
    _parameters = config.getSection('parameters');

    _connectTimeout = config.getAsIntegerWithDefault(
        'options.connect_timeout', _connectTimeout);
    _maxPrice = config.getAsFloatWithDefault('options.max_price', _maxPrice);
    _smsType = config.getAsStringWithDefault('options.sms_type', _smsType);

    _logger.configure(config);
    _credentialResolver.configure(config);
  }

  /// Set references to component.
  ///
  /// - [references]    references parameters to be set.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
    _credentialResolver.setReferences(references);
  }

  /// Gets a command set.
  ///
  /// Return Command set
  @override
  CommandSet getCommandSet() {
    _commandSet ??= SmsCommandSet(this);
    return _commandSet;
  }

  /// Сhecks if SmtpServer is open
  ///
  /// Return bool checking result
  @override
  bool isOpen() {
    return _opened;
  }

  /// Creates the SmtpServer.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// Return 			    Future that receives error or null no errors occured.
  @override
  Future<dynamic> open(String correlationId) async {
    if (_opened) {
      return;
    }

    _credential = await _credentialResolver.lookup(correlationId);

    if (_credential != null && _credential.getAccessId() == null) {
      _credential = null;
    }

    // var credentials = AwsClientCredentials(
    //     accessKey: _credential.getAccessId(),
    //     secretKey: _credential.getAccessKey());
    sns = SNS(region: 'eu-west-1', credentials: AwsClientCredentials(
        accessKey: _credential.getAccessId(),
        secretKey: _credential.getAccessKey()));

    _opened = true;
    _logger.debug(correlationId, 'Connected to AWS SNS');
  }

  /// Closes the SmtpServer and frees used resources.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// Return 			  Future that receives error or null no errors occured.
  @override
  Future<dynamic> close(String correlationId) async {
    _opened = null;
  }

  String getLanguageTemplate(dynamic value, [String language = 'en']) {
    if (value == null) return value;
    if (value is String) return value;

    // Set default language
    language = language ?? 'en';

    // Get template for specified language
    var template = value[language];

    // Get template for default language
    template ??= value['en'];

    return '' + template;
  }

  String renderTemplate(dynamic value, ConfigParams parameters,
      [String language = 'en']) {
    var template = getLanguageTemplate(value, language);
    return template != null ? render(template, parameters) : null;
  }

  /// Send the message
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [message]              a message to be send.
  /// - [parameters]              an additional parameters to be send.
  @override
  Future sendMessage(String correlationId, SmsMessageV1 message,
      ConfigParams parameters) async {
    // Skip processing if sms is disabled or message has no destination
    if (!_opened || message.to == null) {
      throw BadRequestException(correlationId, 'SMS_DISABLED',
          'sms disabled, or sms recipient not set');
    }

    parameters = _parameters.override(parameters);

    var text = renderTemplate(message.text, parameters);

    var attr = <String, MessageAttributeValue>{
      'AWS.SNS.SMS.SenderID': MessageAttributeValue(
          dataType: 'String', stringValue: message.from ?? _messageFrom),
      'AWS.SNS.SMS.MaxPrice': MessageAttributeValue(
          dataType: 'Number', stringValue: _maxPrice.toString()),
      'AWS.SNS.SMS.SMSType':
          MessageAttributeValue(dataType: 'String', stringValue: _smsType)
    };
    try {
      await sns.publish(
          message: text,
          phoneNumber: message.to,
          messageStructure: 'String',
          messageAttributes: attr);
    } on Exception catch (ex) {
      // debug
       print(ex);

      _logger.error(correlationId, ex, 'Message not sent');
    }
  }

  ConfigParams makeRecipientParameters(
      SmsRecipientV1 recipient, ConfigParams parameters) {
    parameters = _parameters.override(parameters);
    parameters.append(recipient);
    return parameters;
  }

  /// Send the message to recipient
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [recipient]              a recipient of the message.
  /// - [message]              a message to be send.
  /// - [parameters]              an additional parameters to be send.
  @override
  Future sendMessageToRecipient(String correlationId, SmsRecipientV1 recipient,
      SmsMessageV1 message, ConfigParams parameters) async {
    // Skip processing if sms is disabled
    if (!_opened || recipient == null || recipient.phone == null) {
      throw BadRequestException(correlationId, 'SMS_DISABLED',
          'smss disabled, or recipients sms not set');
    }

    try {
      var recParams = makeRecipientParameters(recipient, parameters);
      var recLanguage = recipient.language;
      var text = renderTemplate(message.text, recParams, recLanguage);

      var attr = <String, MessageAttributeValue>{
        'AWS.SNS.SMS.SenderID': MessageAttributeValue(
            dataType: 'String', stringValue: message.from ?? _messageFrom),
        'AWS.SNS.SMS.MaxPrice': MessageAttributeValue(
            dataType: 'Number', stringValue: _maxPrice.toString()),
        'AWS.SNS.SMS.SMSType':
            MessageAttributeValue(dataType: 'String', stringValue: _smsType)
      };

      await sns.publish(
          message: text,
          phoneNumber: recipient.phone,
          messageStructure: 'String',
          messageAttributes: attr);
    } on Exception catch (ex) {
      _logger.error(correlationId, ex, 'Message not sent to recipient');
    }
  }

  /// Send the message to recipients
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [recipients]              a recipients of the message.
  /// - [message]              a message to be send.
  /// - [parameters]              an additional parameters to be send.
  @override
  Future sendMessageToRecipients(
      String correlationId,
      List<SmsRecipientV1> recipients,
      SmsMessageV1 message,
      ConfigParams parameters) async {
    // Silentry skip if disabled
    if (_disabled) {
      return;
    }

    // Skip processing if sms is disabled
    if (!_opened || recipients == null || recipients.isEmpty) {
      throw BadRequestException(correlationId, 'SMS_DISABLED',
          'smss disabled, or no recipients sent');
    }

    // Send sms separately to each user
    for (var recipient in recipients) {
      await sendMessageToRecipient(
          correlationId, recipient, message, parameters);
    }
  }
}

// TODO: Fix this after fix sns lib
// class MessageAttributeValueEx extends MessageAttributeValue {
//   MessageAttributeValueEx({
//     @_s.required String dataType,
//     Uint8List binaryValue,
//     String stringValue,
//   }): super(dataType:dataType,
//     binaryValue:binaryValue,
//     stringValue:stringValue);
    

//   Map<String, dynamic> toJson() {
//     return <String, dynamic>{
//       dataType: stringValue,
//       // 'binaryValue': binaryValue,
//       // 'stringValue': stringValue
//     };
//   }
// }
