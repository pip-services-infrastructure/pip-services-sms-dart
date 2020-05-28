import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

class SmsHttpServiceV1 extends CommandableHttpService {
  SmsHttpServiceV1() : super('v1/sms') {
    dependencyResolver.put('controller',
        Descriptor('pip-services-sms', 'controller', 'default', '*', '1.0'));
  }
}
