# HTTP REST Protocol (version 1) <br/> Sms Delivery Microservice

Sms delivery microservice implements a REST compatible API, that can be accessed on configured port.
All input and output data is serialized in JSON format. Errors are returned in [standard format]().

* [SmsMessageV1 class](#class1)
* [SmsRecipientV1 class](#class2)
* [POST /sms/send_message](#operation1)
* [POST /sms/send_message_to_recipient](#operation2)
* [POST /sms/send_messsage_to_recipients](#operation3)

## Data types

### <a name="class1"></a> SmsMessageV1 class

Message object with sender and recipient addresses, subject and content

**Properties:**
    - to: string or [string] - one or several addresses of message recipient
    - from: string - (optional) sender address
    - text: string - (optional) message plain text body 

### <a name="class2"></a> SmsRecipientV1 class

Recipient properties. If some properties are not set, the service
tries to restore them from sms settings.

**Properties:**
- id: string - unique user id
- name: string - (optional) user full name
- phone: string - (optional) primary user sms
- language: string - (optional) user preferred language

## Operations

### <a name="operation1"></a> Method: 'POST', route '/sms\_delivery/send\_message'

Sends sms message to specified address or addresses

**Arguments:** 
- message: SmsMessageV1 - message to be sent
- parameters: Object - (optional) template parameters

**Response body:**
error or null for success

### <a name="operation2"></a> Method: 'POST', route '/sms\_delivery/send\_message\_to_recipient'

Sends sms message to specified recipient

**Request body:** 
- recipient: SmsRecipientV1 - recipient properties, including id
- message: SmsMessageV1 - message to be sent
- parameters: Object - (optional) template parameters

**Response body:**
error or null for success

### <a name="operation3"></a> Method: 'POST', route '/sms\_delivery/send\_message\_to_recipients'

Sends sms message to multiple recipients

**Request body:** 
- recipients: SmsRecipientV1[] - array of recipient properties, including id
- message: SmsMessageV1 - message to be sent
- parameters: Object - (optional) template parameters

**Response body:**
error or null for success
