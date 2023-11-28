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




# Trouble shooting
- If advterising and scanning too slow, wait for several minites to scan the device, need to check fast/slow interval/window in perpheral and scan interval/window parameter.
- If need to do some other actions after connected, but need to wait a few moment, you need to make sure `sup_to` parameter large enough to make sure it will not disconnect beacuse of timeout of receive PDU after connected. Therefore, if none of event except DISCONN_IND received in perpherial, it maybe this problem.
- In pairing, you need to notice `io_capabilitie_local_device` parameter, perpherial should have `DISPLAY_ONLY` capacity at least, and central shoule have `KEYBOARD_ONLY` capacity at least. 
- In pairing, id you set MITM protection policy as `BLE_GAP_SEC_MITM_STRICT`, you must display and input passkey in pairing progress. But if you set this parameter as `BLE_GAP_SEC_MITM_BEST_EFFORT`, you don't need to input passkey.
- Coded PHY can't transmit CTE.
- Subrate parameter affect CTE, refer to P2528 in spec v5.4
