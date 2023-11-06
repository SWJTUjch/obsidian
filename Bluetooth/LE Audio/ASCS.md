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



















