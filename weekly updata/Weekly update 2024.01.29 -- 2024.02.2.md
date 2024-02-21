- [ ] BLE V3 smoke test
	- [ ] BLEV3CaseHandler class
		- [x] Distinguish empty and case device by name
		- [x] Rename \_\_reset_empty_device to \_\_reset\_device
		- [x] Set \_\_run_case as \_run_case
	- [ ] device Class
	- [ ] CaseHandler class
	- [ ] Group discuss
		- Do we store log in BB-tools or in bttest directory?
		- Add empty image in net-disk?
		- Use PDU reset?
- [ ] LE Audio Scenario 9
	- [ ] CMake
	- [ ] flow chart
	- [ ] code
- [x] Mac reset and auto start
	- [x] Reset
	- [x] start Xcode and Amphetamine
```shell
55 15 * * 0 /sbin/shutdown -r now 
@reboot open -a Xcode 
@reboot open -a Amphetamine
```