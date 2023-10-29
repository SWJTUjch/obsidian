# Concepts
- Audio Channel: A flow of audio data, which might be encoded or not, that can be assigned to a single Audio Location
- Audio Sink: Receives unicast audio data from Audio Sources
- Audio Source: Transmits unicast audio data to Audio Sinks
- Audio Stream Endpoint (ASE): The endpoint of a unicast Audio Stream, which audio data flows to or from; exists on the server.


# Service
- There shall be no more than one Audio Stream Control Service (ASCS) instance on a server. 
- ASCS shall be a `Primary Service` and the service UUID shall be set to Audio Stream Control