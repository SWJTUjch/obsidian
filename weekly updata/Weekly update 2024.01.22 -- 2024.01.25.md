- [ ] PWM duty cycle code refine
	- [ ] Verified, need refine again and commit code.
- [ ] Nordic code
	- [ ] test plan
	- [ ] pairing 10 modes
	- [ ] notify verify
	- [ ] disconnect
	- [ ] use uart interact with pulsar user
	- [ ] pulsar interact with Nordic
- [ ] BLE V3 smoke test
	- [ ] refine flow chart
	- [ ] BLEV3CaseHandler class
	- [ ] device Class
	- [ ] CaseHandler class
	- [ ] Group discuss
		- Do we store log in BB-tools or in bttest directory?
		- Add empty image in net-disk?
		- Distinguish empty and case device by name
		- Rename \_\_reset_empty_device to \_\_reset\_device
		- Set \_\_run_case sa \_run_case
		- Use PDU reset?
```python
__run_case(): int, int  
"""
run hciCmdToolPy script, loop check running.txt and wait result.txt
"""
__record_case_result(): int  
"""
record not run cases result
""" 
__stop_all_threads  
"""
kill python process
"""
__init_devices
"""
generate image url and initiate devices
"""
```
