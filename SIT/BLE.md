Introduction 
	FreeRTOS 
		Task and scheduling 
			create
			priority-> asynchronous problem
			vtaskdelay
		Message queue
	BLE
        central and peripheral
        command and event
        spac v5.4
    
BLE stack
	MITM configuration
    input output capacity
    adv interval
    task function
    ABS layer

R_BLE_Execute
	wait for a flag
	call a function on a callback
	different implementation in BM and FreeRTOS

example
advertising and scan

trouble shooting
	can't scan
	pairing
	can't trigger event
		event type
			triggered by self
				return right?
				find the event in whole project
				parameters right?
				resend by a callback?
			received from remote
				return right?
				sniffer
	asynchronous problem
		abstract layer function
		callback can't interrupt a callback





