# Configuration Guide <br> SMS Delivery Microservice

Sms delivery microservice configuration structure follows the 
[standard configuration](https://github.com/pip-services/pip-services3-container-node/doc/Configuration.md) 
structure. 

* [controller](#controller)
* [service](#service)
  - [http](#service_http)


## <a name="controller"></a> Controller

Controller has the following configuration properties:
- message: hashmap - Message default properties
  - from: string - sender address
- options: hashmap - default options
  - connect_timeout: num - timeout
  - max_price: num - max price
  - sms_type: string - sms type
- credential: CredentialParams - AWS credentials


Example:
```yaml
- descriptor: "pip-services-sms:controller:default:default:1.0"
  message:
    from: 'somebody@somewhere.com'
    to: 'somebody@somewhere.com'
  credential:
    access_id: 'XXXXXXXXX'
    access_key: 'XXXXXXXXX'
```

## <a name="service"></a> Services

The **service** components (also called endpoints) expose external microservice API for the consumers. 
Each microservice can expose multiple APIs (HTTP/REST, Thrift or Seneca) and multiple versions of the same API type.
At least one service is required for the microservice to run successfully.

### <a name="service_http"></a> Http

HTTP/REST service has the following configuration properties:
- connection: object - HTTP transport configuration options
  - protocol: string - HTTP protocol - 'http' or 'https' (default is 'http')
  - host: string - IP address/hostname binding (default is '0.0.0.0')
  - port: number - HTTP port number

A detailed description of HTTP protocol version 1 can be found [here](HttpProtocolV1.md)

Example:
```yaml
- descriptor: "pip-services-sms:service:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 3000
```