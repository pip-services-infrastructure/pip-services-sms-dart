import 'package:pip_services_sms/pip_services_sms.dart';

void main(List<String> args) {
  try {
    var proc = SmsProcess();
    proc.configPath = './config/config.yml';
    proc.run(args);
  } catch (ex) {
    print(ex);
  }
}
