import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../src/data/version1/SmsMessageV1.dart';
import '../../src/data/version1/SmsRecipientV1.dart';

abstract class ISmsController {
  /// Send the message
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [message]              a message to be send.
  /// - [parameters]              an additional parameters to be send.
  Future sendMessage(
      String correlationId, SmsMessageV1 message, ConfigParams parameters);

  /// Send the message to recipient
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [recipient]              a recipient of the message.
  /// - [message]              a message to be send.
  /// - [parameters]              an additional parameters to be send.
  Future sendMessageToRecipient(String correlationId, SmsRecipientV1 recipient,
      SmsMessageV1 message, ConfigParams parameters);

  /// Send the message to recipients
  ///
  /// - [correlation_id]    (optional) transaction id to trace execution through call chain.
  /// - [recipients]              a recipients of the message.
  /// - [message]              a message to be send.
  /// - [parameters]              an additional parameters to be send.
  Future sendMessageToRecipients(
      String correlationId,
      List<SmsRecipientV1> recipients,
      SmsMessageV1 message,
      ConfigParams parameters);
}
