# Concepts
- Audio Channel: A flow of audio data, which might be encoded or not, that can be assigned to a single Audio Location
- Audio Sink: Receives unicast audio data from Audio Sources
- Audio Source: Transmits unicast audio data to Audio Sinks
- Audio Stream Endpoint (ASE): The endpoint of a unicast Audio Stream, which audio data flows to or from; exists on the server.


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

# Service characteristics 
## Audio Stream Endpoints
- An ASE characteristic exposes information about an ASE, including the state of the ASE state machine, codec parameters, QoS parameters, and mapping information for any underlying CIS configuration.
- An ASE characteristic represents the state of an ASE, which can be coupled to a CIS to establish a unicast Audio Stream. For each ASE characteristic (distinguished by their attribute handles), the server shall expose separate ASE characteristic values for each client. A client reading or being notified of an ASE characteristic value cannot gain any information about the ASE characteristic value at the same attribute handle that is exposed for a different client.
- The server can expose a maximum of one Sink ASE per client per Sink ASE characteristic and one Source ASE per client per Source ASE characteristic, and the server should expose at a minimum the number of Sink ASE characteristics and/or Source ASE characteristics that it needs to support the number of concurrent established unicast Audio Streams that it can support for a single client.
![](ASE_CS.png)
- Same characteristic have same UUID, but have different handle, handle indicate different stream, ASE_ID indicate different client.














