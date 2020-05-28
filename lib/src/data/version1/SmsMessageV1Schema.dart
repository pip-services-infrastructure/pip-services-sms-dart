import 'package:pip_services3_commons/pip_services3_commons.dart';

class SmsMessageV1Schema extends ObjectSchema {
  SmsMessageV1Schema() : super() {
    withOptionalProperty('from', TypeCode.String);
    withOptionalProperty('to', TypeCode.String);
    withOptionalProperty('text', null);
  }
}
