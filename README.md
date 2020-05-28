# Sms Delivery Microservice

This is a sms sending microservice from Pip.Services library. 
This microservice is intended mostly to send sms to specified recipients.

The microservice currently supports the following deployment options:
* Deployment platforms: Standalone Process
* External APIs: HTTP/REST

<a name="links"></a> Quick Links:

* [Download Links](doc/Downloads.md)
* [Development Guide](doc/Development.md)
* [Configuration Guide](doc/Configuration.md)
* [Deployment Guide](doc/Deployment.md)
* Client SDKs
  - [Dart SDK](https://github.com/pip-services-infrastructure/pip-clients-sms-dart)
* Communication Protocols
  - [HTTP Version 1](doc/HttpProtocolV1.md)

##  Contract

Logical contract of the microservice is presented below. For physical implementation (HTTP/REST, Thrift, Seneca, Lambda, etc.),
please, refer to documentation of the specific protocol.

```dart
class SmsMessageV1 {
  String from;
  String to;
  dynamic text;
}

class SmsRecipientV1 {
  String id;
  String name;
  String phone;
  String language;
}

abstract class ISmsV1 {
  Future sendMessage(String correlationId, SmsMessageV1 message, ConfigParams parameters);

  Future sendMessageToRecipient(String correlationId, SmsRecipientV1 recipient, SmsMessageV1 message, ConfigParams parameters);

  Future sendMessageToRecipients(String correlationId, List<SmsRecipientV1> recipients, SmsMessageV1 message, ConfigParams parameters);
}
```


Message text can be set by handlebars template, that it processed using parameters set.
Here is an example of the template:

```text
Dear {{ name }},
Please, help us to verify your sms address. Your verification code is <%= code %>.
{{ signature }}
```

## Download

Right now the only way to get the microservice is to check it out directly from github repository
```bash
git clone git@github.com:pip-services-infrastructure/pip-services-sms-dart.git
```

Pip.Service team is working to implement packaging and make stable releases available for your 
as zip downloadable archieves.

## Run

Add **config.yml** file to the root of the microservice folder and set configuration parameters.
As the starting point you can use example configuration from **config.example.yml** file. 
Example of microservice configuration
```yaml
---
- descriptor: "pip-services-commons:logger:console:default:1.0"
  level: "trace"

- descriptor: "pip-services-sms:controller:default:default:1.0"
  message:
    from: '+12453453445'
    to: '+79532347823'
  credential:
    access_id: 'xxx'
    access_key: 'xxx'
  
- descriptor: "pip-services-sms:service:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 8080
```
 
For more information on the microservice configuration see [Configuration Guide](Configuration.md).

Start the microservice using the command:
```bash
dart ./bin/run.dart
```

## Use

The easiest way to work with the microservice is to use client SDK. 
The complete list of available client SDKs for different languages is listed in the [Quick Links](#links)

If you use dart, then get references to the required libraries:
- Pip.Services3.Commons : https://github.com/pip-services3-dart/pip-services3-commons-dart
- Pip.Services3.Rpc: https://github.com/pip-services3-dart/pip-services3-rpc-dart


Add **pip-services3-commons-dart**, **pip-services3-rpc-dart** and **pip-services_sms** packages
```dart
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

import 'package:pip_services_sms/pip_services_sms.dart';

```

Define client configuration parameters that match configuration of the microservice external API
```dart
// Client configuration
var config = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = SmsHttpClientV1(config);

// Connect to the microservice
await client.open(null);
    
    // Work with the microservice
    ...
});
```

Now the client is ready to perform operations
```dart
// Send sms message to address
var message = SmsMessageV1(to: '+13452345324', 
                             text: 'This is a test message. Please, ignore it');

await client.sendMessage(
    null,
    message,
    null
);
```

```dart
// Send sms message to users
var recipient1 = SmsRecipientV1(id: '1', phone: '+123455534');
var recipient2 = SmsRecipientV1(id: '2', phone: '+123408289');
var message = SmsMessageV1(text: 'This is a test message. Please, ignore it');
await client.sendMessageToRecipients(
    null,
    [
        recipient1,
        recipient2
    ],
    message,
    null
);
```

## Acknowledgements

This microservice was created and currently maintained by
- **Sergey Seroukhov**
- **Nuzhnykh Egor**.