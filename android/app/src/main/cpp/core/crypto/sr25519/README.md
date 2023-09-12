# C Implementation of SR25519 Signature Algorithm

## Building
```
git clone https://github.com/usetech-llc/sr25519
cd sr25519
cmake .
make
```

## Testing

### Setup testing environment using Docker

Testing is done using the API repository, which allows to perform a transfer as an additional integration test.

For convenience the Dockerfile is provided that installs all API dependencies as needed and builds it. In order to execute single API tests manually, please have docker CE installed, then clone API repository and run following commands (first docker build takes ~20 minutes to run for the first time):
```
$ git clone https://github.com/usetech-llc/polkadot_api_cpp
$ cd polkadot_api_cpp
$ git checkout sr25519code
$ docker build -t cppapi .
$ docker run -it --rm cppapi /bin/sh
# cd polkadot_api_cpp
```

### Run acceptance tests

#### Verify signature using UI

First, run sign_message test to get a signature for "hello world" message. Both Kusama and Alexander use the same version of signature, so there is no need to test on both.

```
# bin/sign_message 
Message: hello world
Signature: 1C5694A7489F9C4DA6F937C6C158421EECBE93C101389F5E734B6C652860314F13D698BB15670577CC84FF7BFD5165C5C2827C33A4F6F29906819A13F92A9F0A
Signature verified successfully using C SR25519 library
Signature verification failed successfully with wrong message using C SR25519 library
success
```

Next, copy the information below as well as the newly generated signature and paste in the UI to verify:

```
URL: https://polkadot.js.org/apps/#/toolbox/verify
Address: EiEQJ6eFXRErfeiwuZHQmskwwamu3M7H1AiX8vKRoKKpeFR
Message: "hello world"
Signature example: 0x1C5694A7489F9C4DA6F937C6C158421EECBE93C101389F5E734B6C652860314F13D698BB15670577CC84FF7BFD5165C5C2827C33A4F6F29906819A13F92A9F0A
```

#### Transfer some testDOTs on Alexander network

The transfer API method was modified in the sr25519code branch to use C library for signing instead of Rust library. This code snippet demonstrates that (see application.cpp file around lines 1398-1400):
```
    // Replace SR25519 Rust version with C version 
    //sr25519_sign(sig, te.signature.signerPublicKey, secretKeyVec.data(), signaturePayloadBytes, payloadLength);
    sign011_s(te.signature.signerPublicKey, secretKeyVec.data(), signaturePayloadBytes, payloadLength, sig);
``` 

In order to test, run the transfer unit test:
```
bin/transfer <sender address> <recipient address> <amount in fDOTs> <sender private key (hex)>

for example:

bin/transfer 5ECcjykmdAQK71qHBCkEWpWkoMJY6NXvpdKy8UeMx16q5gFr 5FpxCaAovn3t2sTsbBeT5pWTj2rg392E8QoduwAyENcPrKht 1000000000000000000 0xABCDEF123.....123
(private key was corrupted on purpose, both hex formats with or without leading 0x are supported)
```

Expect output such as:
```
...
2019-12-17 12:19:03,460 INFO [default] WS sent message: {"id": 5, "jsonrpc": "2.0", "method": "author_submitAndWatchExtrinsic", "params": ["0x390281FF5E8135DC17F025CA044780631EF89E21310B590B429E238786DD88DFEC7B0F1D8453D7ED03C24A40A193375325F39E3C1D246B5283CA9584B9B433C7C10AAA5DB95282F31539CC2A03C80737A2C65C465B8591BB7013399111E963A3794E31006902000300FFA673C814FAABAB0F81F2837D79DF6ACA044DF12BA9B727110FEBF95BFF2D0C01070010A5D4E8"]}
2019-12-17 12:19:03,460 INFO [default] Message 5 was sent
2019-12-17 12:19:04,074 INFO [default] WS Received Message: {"jsonrpc":"2.0","method":"author_extrinsicUpdate","params":{"result":"ready","subscription":684}}
2019-12-17 12:19:04,074 INFO [default] Message received: {"jsonrpc":"2.0","method":"author_extrinsicUpdate","params":{"result":"ready","subscription":684}}
2019-12-17 12:19:04,074 INFO [default] WS Received Message: {"jsonrpc":"2.0","result":684,"id":5}
2019-12-17 12:19:04,074 INFO [default] Message received: {"jsonrpc":"2.0","result":684,"id":5}
2019-12-17 12:19:04,074 INFO [default] Subscribed with subscription ID: 684


   ---=== Transaction was registered in network ===--- 


2019-12-17 12:19:04,690 INFO [default] runWsMessages Thread exited
success
```
