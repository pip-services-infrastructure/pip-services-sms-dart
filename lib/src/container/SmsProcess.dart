import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import '../build/SmsServiceFactory.dart';

class SmsProcess extends ProcessContainer {
  SmsProcess() : super('sms', 'Sms delivery microservice') {
    factories.add(SmsServiceFactory());
    factories.add(DefaultRpcFactory());
  }
}
