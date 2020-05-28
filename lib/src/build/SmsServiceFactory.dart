import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import '../logic/SmsController.dart';
import '../services/version1/SmsHttpServiceV1.dart';

class SmsServiceFactory extends Factory {
  static var ControllerDescriptor =
      Descriptor('pip-services-sms', 'controller', 'default', '*', '1.0');
  static var HttpServiceDescriptor =
      Descriptor('pip-services-sms', 'service', 'http', '*', '1.0');

  SmsServiceFactory() : super() {
    registerAsType(SmsServiceFactory.ControllerDescriptor, SmsController);
    registerAsType(SmsServiceFactory.HttpServiceDescriptor, SmsHttpServiceV1);
  }
}
