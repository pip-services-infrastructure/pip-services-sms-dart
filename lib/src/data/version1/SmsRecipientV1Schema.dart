import 'package:pip_services3_commons/pip_services3_commons.dart';

class SmsRecipientV1Schema extends ObjectSchema {
  SmsRecipientV1Schema() : super() {
    withRequiredProperty('id', TypeCode.String);
    withOptionalProperty('name', TypeCode.String);
    withOptionalProperty('phone', TypeCode.String);
    withOptionalProperty('language', TypeCode.String);
  }
}
