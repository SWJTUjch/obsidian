- [ ] PWM duty cycle code refine
	- [ ] 100% test not pass because narrow pulse after a period.
		- After detected edge, delay several cycle to test it's high or low to verify rising edge or falling edge.
- [ ] Nordic code
	- [x] connect
	- [ ] disconnect
	- [ ] pairing
	- [ ] notify verify
	- [ ] 
- [ ] Group discuss BLE V3 smoke test
	- [ ] ==Change iamge name to xxx.bin==
	- [ ] ==Ask total expect running time==
	- [ ] Can we reset board after generate log (\_\_wait_test_start, L208).
	- [ ] ==What should we do if blocked?==
	- [ ] Is it nessary to record test failed in the first time?
	- [ ] Do we need retry if blocked or result.txt not exist?
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


```python
import yaml

def read_yaml(file_path):
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    return data

def get_yaml_keys(file_path):
    data = read_yaml(file_path)
    keys = set(data.keys())
    return keys

def read_txt(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    return lines

def find_missing_items(yaml_keys, txt_lines):
    missing_items = yaml_keys.difference(txt_lines)
    return missing_items

def write_txt(file_path, missing_items):
    with open(file_path, 'w') as file:
        for item in missing_items:
            file.write(item + '\n')

def process_files(yaml_file, txt_file, output_file):
    yaml_keys = get_yaml_keys(yaml_file)
    txt_lines = set(read_txt(txt_file))
    missing_items = find_missing_items(yaml_keys, txt_lines)
    write_txt(output_file, missing_items)

# 示例用法
yaml_file = 'path/to/your/yaml/file.yaml'
txt_file = 'path/to/your/txt/file.txt'
output_file = 'path/to/your/output/file.txt'

process_files(yaml_file, txt_file, output_file)

```