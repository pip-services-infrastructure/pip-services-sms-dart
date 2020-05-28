# Examples for Sms Delivery Microservice

This is a sms sending microservice from Pip.Services library. 
This microservice is intended mostly to send sms to specified recipients.

Define configuration parameters that match the configuration of the microservice's external API
```dart
// Service/Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the service
```dart
controller = SmsController();
controller.configure(ConfigParams());

service = SmsHttpServiceV1();
service.configure(httpConfig);

var references = References.fromTuples([
    Descriptor('pip-services-sms', 'controller', 'default',
        'default', '1.0'),
    controller,
    Descriptor(
        'pip-services-sms', 'service', 'http', 'default', '1.0'),
    service
]);

controller.setReferences(references);
service.setReferences(references);

await controller.open(null);
await service.open(null);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = SmsHttpClientV1(config);

// Configure the client
client.configure(httpConfig);

// Connect to the microservice
try{
  await client.open(null)
}catch() {
  // Error handling...
}       
// Work with the microservice
// ...
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

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services-infrastructure/pip-services-sms-dart/tree/master/test).
