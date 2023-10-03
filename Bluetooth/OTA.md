1. Get peaks by peaks_download.sh
```bash
./peaks_download.sh
```
2. Update mcuboot
```shell
cd ra/mcu-tools
mv mcuboot MCUboot
cd MCUboot/
git checkout -b renesas_main_1_9_selix  origin/renesas_main_1_9_selix
```
3. update FreeRTOS
```bash
cd ../../freertos/
cd ../aws
git clone https://github.com/renesas/FreeRTOS.git, git submodule update --init
git clone https://github.com/renesas/FreeRTOS.git
git submodule update --init
cd ../fsp/inc
git checkout -b PULSAR-110-pulsar-develop-main origin/PULSAR-110-pulsar-develop-main
```
4. update submodules
```bash
cd re/arm/CMSIS_5
git clone git@pbgitap01.rea.renesas.com:peaks/CMSIS_5.git
```
cp sit/UC_Application/test_files/shared/tools_cfg.xml test_files/shared




docker run -d -it -v /local/workspace/:/home/fspdev/code 192.168.103.43:5000/renesas/pulsar/20210308 /bin/bash



CMSIS_5: git clone git@pbgitap01.rea.renesas.com:peaks/CMSIS_5.git
Unity: git clone https://github.com/ThrowTheSwitch/Unity.git
erpc: git clone https://github.com/EmbeddedRPC/erpc.git
git reset --hard 6a571caf6d5042af5d63ff8745f2e4b24e14bc9f
rpmsg-lite: git clone https://github.com/NXPmicro/rpmsg-lite.git
git reset --hard 9775c19b960faa311df8bfe10107d7be5ef59db2
