# steps
- 收集进行测试的case并轮流执行下面步骤：
- 检查当前设备数量是否满足当前case所需设备数量的要求，其中当前case所需设备数量在case_config中以director的形式存储了
- 创建log目录，计算测试时间，并创建所需设备instance，设备分为用到的板子和无用的板子，其中无用的板子下载空的image。如果下载失败，则该case结束。重启下载了空image的板子
- 