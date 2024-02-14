# class





# steps
- 收集进行测试的case并轮流执行下面步骤：
- 检查当前设备数量是否满足当前case所需设备数量的要求，其中当前case所需设备数量在case_config中以director的形式存储了
- 创建log目录，计算测试时间，并创建所需设备instance
	- 
- 设备分为用到的板子和无用的板子，其中无用的板子下载空的image。如果下载失败，则该case结束。
	- 可以重试五次，需要重启jlink和板子，但是重启之后第一次经常下载不进去，所以需要下载两次
	- 使用xmlrpc方法和server连接，在server端下载img
- 重启下载了空image的板子
- 开始测试case
	- 为每个板子创建一个线程运行该板子的case
	- 等待每个板子开始运行，如果在规定时间内没有全部运行，就让所有板子停止运行。否则就一直等到结束。
		- 
	- 停止所有线程
- 所有case结束后生成xml


- run_case
	- \_\_start_collect_log
		- \_\_generate_log_collector
	- \_\_wait_test_start
		- \_\_wait_logfile_created
		- \_\_reset_device  (reset_board)
		- \_\_extract_key_message
	- \_\_wait_test_end
		- \_\_check_key_message
			- \_\_record_case_failed_reason
		- \_\_check_test_time_info
	- \_\_stop_collect_log


scenario_api_client

scenario_api_test
/home/cn1947/workspace/chunhao_test/Automation/platforms/bttest/tests/scenario_api/config/scenario_api_test/scenario_case_config.yaml
/home/cn1947/workspace/chunhao_test/Automation/platforms/bttest/tests/scenario_api/config/devices.yaml
/home/cn1947/workspace/chunhao_test/Automation/platforms/bttest/tests/scenario_api/config/scenario_api_test/execution_api_config.yaml
http://jenkins-spsd.verisilicon.com/image/gerrit_review_verification/33086/pulsar_ble/images/
10.10.184.15
8002
-C
case_5x3



pulsar_ble_smoke_test
/home/cn1947/workspace/chunhao_test/Automation/platforms/bttest/tests/scenario_api/config/pulsar_ble_smoke_test/pulsar_ble_smoke_case_config.yaml
/home/cn1947/workspace/chunhao_test/Automation/platforms/bttest/tests/scenario_api/config/devices.yaml
/home/cn1947/workspace/chunhao_test/Automation/platforms/bttest/tests/scenario_api/config/pulsar_ble_smoke_test/execution_pulsar_ble_smoke_config.yaml
http://jenkins-spsd.verisilicon.com/image/gerrit_review_verification/32983/pulsar_ble/images/
10.10.184.15
8002
-C
case0
