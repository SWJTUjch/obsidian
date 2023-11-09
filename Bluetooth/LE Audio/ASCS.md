# Concepts
- Audio Sink: Receives unicast audio data from Audio Sources
- Audio Source: Transmits unicast audio data to Audio Sinks
- Audio Stream Endpoint (ASE): The endpoint of a unicast Audio Stream, which audio data flows to or from; exists on the server.
- read/write/notify in GATT


# Service
- There shall be no more than one Audio Stream Control Service (ASCS) instance on a server. 
- ASCS shall be a `Primary Service` and the service UUID shall be set to Audio Stream Control
- ASCS can be instantiated on devices that can accept the establishment of `unicast Audio Streams`.

# Characteristic
- Sink ASE Characteristic: The server is said to act as Audio Sink for that ASE. There can be more than one Sink ASE characteristic on the server.
- Source ASE Characteristic: The server is said to act as Audio Source for that ASE. There can be more than one Source ASE characteristic on the server.
- ASE Control Point Characteristic: An ASE Control Point characteristic that clients use to configure audio codec parameters, CIS configuration parameters, and Metadata for each ASE exposed by the server. The ASE Control Point characteristic is used to operate on all ASEs, distinguishing each ASE by its ASE_ID value

# ASE state management
![Source ASE](Source_ASE.png)
<center>Source ASE</center>
![](Sink_ASE.png)
<center>Sink ASE</center>
- Configuration, control, and status of an ASE is described in terms of an ASE state machine.
- The state of an ASE is maintained by the server and is shared with a client using ASE characteristics.
- The ASE state machine can be controlled by a client by writing to the ASE Control Point characteristic or, in some instances, autonomously controlled by the server. Changes to the state and/or parameter values of an ASE can be tracked by a client by observing changes to the ASE characteristic value.
- ASE server can notify client.
- CIS can exist except Idle and Codec Configures, because CIS parameters can be configured when QoS configured, but the lost of CIS can't change status expect Streaming and Disabling.
- Start coupling ASE to a CIS in Enable status.
- Why Disabling? Decoupling

# Service characteristics 
## Audio Stream Endpoints
- An ASE characteristic exposes information about an ASE, including the state of the ASE state machine, codec parameters, QoS parameters, and mapping information for any underlying CIS configuration.
- For each ASE characteristic (distinguished by their attribute handles), the server shall expose separate ASE characteristic values for each client. A client reading or being notified of an ASE characteristic value cannot gain any information about the ASE characteristic value at the same attribute handle that is exposed for a different client.
- The server can expose a maximum of one Sink ASE per client per Sink ASE characteristic and one Source ASE per client per Source ASE characteristic, and the server should expose at a minimum the number of Sink ASE characteristics and/or Source ASE characteristics that it needs to support the number of concurrent established unicast Audio Streams that it can support for a single client.
![](ASE_CS.png)
- Same characteristic have same UUID, but have different handle, handle indicate different stream, ASE_ID is unique in same client and in same UUID.
- The server should allocate local resources which can be affected by a change in the state of an ASE as it sees fit. The behavior of the server in deciding whether to accept client requests that can change the state of an ASE is left to the implementation unless otherwise defined by higher layers.
- ASE characteristics
![](ASE_characteristic.png)
- The characteristics can be configured for notifications by using the GATT Write Characteristic Descriptors sub-procedure on the Client Characteristic Configuration descriptor.
- If the characteristic value changed:
	- If connecting and notification is configured, then notify immediately
	- If not connecting but bonded, but notification is configured, then notify when reconnect.

## ASE Control Point
- The ASE Control Point characteristic is an 8-bit enumerated value (known as the opcode) followed by zero or more parameter octets. The opcode is used by the server to determine which ASE Control operation is being initiated by the client. A notification of the ASE Control Point is used to provide a response to a client-initiated ASE Control operation.
- ASE Control Point characteristics
![](ASE_CP_char.png)

# ASE Control operations 
ASE Control operations can be initiated by server or client.
- Initiated by client
	- Success: send a notification of ASE Control Point to client. Can execute all of the operations except Released operation, and send ASE values during that ASE Control operation.
	- Fail: send a notification to client. 
- Initiated by server
	- 
## Config Codec operation 
- Config Codec operation can be initiated by client or server.
- Finish the Config Codec operation, server shell:
	- Transition the ASE to the Codec Configured state and write a value of 0x01 (Codec Configured) to the ASE_State field.
	- Write the Config Codec operation parameter values to the matching Additional_ASE_Parameters fields.
	- Write the server’s preferred values for the remaining Additional_ASE_Parameters fields.
## Config QoS operation 
- The Config QoS operation is used to request a CIS configuration preference with the server and to assign identifiers to the CIS.
- If a client requests a Config QoS operation for an ASE that would result in more than one Sink ASE having identical CIG_ID and CIS_ID parameter values for that client, or that would result in more than one Source ASE having identical CIG_ID and CIS_ID parameter values for that client, the server shall not accept the Config QoS operation for that ASE. （如果一个client进行的配置会使所有的sink/source ASE变为与client相同的QoS配置，就会拒绝QoS的改变）

## Enable operation
- If a CIS has been established and the server is acting as Audio Sink for the ASE, and if the server is ready to receive audio data transmitted by the client, the server may autonomously initiate the Receiver Start Ready, without first sending a notification of the ASE characteristic value in the Enabling state. （如果已经建立了CIS连接，并且server作为sink准备接收数据了，server就会直接进行下一步，而不用发notification）

## Receiver Start Ready operation
- client(sink) -> server(source): ==indicate== client is ready to consume audio data transmitted by the server. 
- client(source) <- server(sink): ==inform== a client acting as Audio Source that the server is ready to consume audio data transmitted by the client.

## Disable operation

## Receiver Stop Ready operation 
- client(Sink), inform a server acting as Audio Source that the client is ready to stop consuming audio data transmitted by the server.

## Released operation 
- The Released operation shall be initiated autonomously by the server if: 
	- The server has detected the loss of the LE-ACL for an ASE in any state, or 
	 - The Release operation for an ASE has been completed and the server controller has indicated that the underlying CIS for the ASE has been torn down.

- When initiating the Released operation, the server shall follow the steps in one of the following lists.
	- If the server wants to cache a codec configuration:
		- Transition the ASE to the Codec Configured state and write a value of 0x01 (Codec Configured) to the ASE_State field.
		• Write to Additional_ASE_Parameters.
	- If the server does not want to cache a codec configuration: 
		• Transition the ASE to the Idle state and write a value of 0x00 (Idle) to the ASE_State field. 
		• Delete any Additional_ASE_Parameters fields present.





