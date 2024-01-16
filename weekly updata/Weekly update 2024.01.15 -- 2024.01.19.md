- [ ] PWM duty cycle code refine
	- [ ] 100% test not pass because narrow pulse after a period.
		- After detected edge, delay several cycle to test it's high or low to verify rising edge or falling edge. (code done, wait for verify)
- [ ] Nordic code
	- [x] connect
	- [ ] use UART interact with Nordic user
	- [ ] pairing 10 modes
	- [ ] notify verify
	- [ ] disconnect
	- [ ] use uart interact with pulsar user
	- [ ] pulsar interact with Nordic
- [ ] BLE V3 smoke test
	- [x] Group review test plan
	- [ ] refine flow chart
	- [ ] BLEV3CaseHandler class
	- [ ] device Class
	- [ ] CaseHandler class
	- [ ] New questions 
		- Do we store log in BB-tools or in bttest directory?
```python
__run_case(): int, int  
"""
run hciCmdToolPy script, loop check running.txt and wait result.txt

开启一个线程，在这个线程里运行python脚本，命令是：“python main.py --smoke --debug 1 --trace 1”， sleep5分钟之后，检查running.txt文件是否存在，如果不存在，则判断result.txt是否存在，如果存在，则直接返回，如果不存在，则创建这个文件并返回。如果running.txt存在，检查上次更新时间距离当前时间是否超过5分钟，如果超过五分钟，将该文件重命名为result.txt，如果没有超过五分钟，就继续sleep并执行上述sleep之后步骤，
"""
__record_case_result(): int  
"""
record not run cases result

从一个yaml文件中读取所有的key，并将其存储在一个字典中。然后从一个txt文件中遍历每一行，这个txt文件中每一行都是一条log，不同项之间用空格分隔，只需要读取第一项并且查看这个项目再字典中是否有匹配项，遍历这个txt之后，把所有的字典中有但是txt中没有的项输出到txt中。
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
