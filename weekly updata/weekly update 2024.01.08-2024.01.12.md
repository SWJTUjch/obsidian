- [ ] PWM duty cycle code refine
	- [x] Use UART to trigger Teensy start detect edge, and transmit result by UART.
	- [ ] 100% test not pass because narrow pulse after a period.
		- After detected edge, delay several cycle to test it's high or low to verify rising edge or falling edge.
- [ ] Nordic code
- [ ] BLE V3 smoke test
	- [ ] ==Change iamge name to xxx.bin==
	- [ ] ==Ask total expect running time==
	- [ ] Can we reset board after generate log (\_\_wait_test_start, L208).
	- [ ] ==What should we do if blocked?==
	- [ ] Is it nessary to record test failed in the first time?
	- [ ] Do we need retry if blocked or result.txt not exist?
- [ ] smoke test new idea
```python
__run_case(): int, int  
"""
run hciCmdToolPy script, loop check running.txt and wait result.txt
"""
开启一个线程，在这个线程里运行python脚本，命令是：“python main.py --smoke --debug 1 --trace 1”， sleep5分钟之后，检查running.txt文件是否存在，如果不存在，则判断result.txt是否存在，如果存在，则直接返回，如果不存在，则创建这个文件并返回。如果running.txt存在，检查上次更新时间距离当前时间是否超过5分钟，如果超过五分钟，将该文件重命名为result.txt，如果没有超过五分钟，就继续sleep并执行上述sleep之后步骤，
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