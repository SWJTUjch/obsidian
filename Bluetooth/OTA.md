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
rm -rf FreeRTOS
git clone https://github.com/renesas/FreeRTOS.git
cd FreeRTOS
git submodule update --init
cd ../../fsp/inc
git checkout -b PULSAR-110-pulsar-develop-main origin/PULSAR-110-pulsar-develop-main
```
4. update submodules
```bash
cd ../../../ra/arm
rm -rf ./CMSIS_5
git clone git@pbgitap01.rea.renesas.com:peaks/CMSIS_5.git
cd ../../ra/EmbeddedRPC
rm -rf ./erpc
git clone https://github.com/EmbeddedRPC/erpc.git
cd erpc
git reset --hard 6a571caf6d5042af5d63ff8745f2e4b24e14bc9f
cd ../../../ra/ThrowTheSwitch
rm -rf ./Unity
git clone https://github.com/ThrowTheSwitch/Unity.git
cd ../../ra/NXPmicro
rm -rf rpmsg-lite
git clone https://github.com/NXPmicro/rpmsg-lite.git
cd rpmsg-lite
git reset --hard 9775c19b960faa311df8bfe10107d7be5ef59db2
```
5. download SIT
```bash
cd ../../../../peaks
git clone "ssh://cn1947@gerrit-spsd.verisilicon.com:29418/Renesas/VSI/SIT"
mv SIT sit
cp sit/UC_Application/test_files/shared/tools_cfg.xml test_files/shared
```
6. run docker
```bash
sudo docker run -d -it -v /local/workspace/OTA/peaks:/home/fspdev/code 192.168.103.43:5000/renesas/pulsar/20210308 /bin/bash
docker container ls
docker exec -it xxxxxxx /bin/bash
```
7. install python modules
```bash
pip3 install click cryptography cbor2 intelhex
```
8. compile
```shell
scons --build=rm_mcuboot_usod_app --board=ra4w3_evb --compiler=gcc --static_analyze=export --skip_srec_check
```
9. stop docker 
```bash
sudo docker stop 12ab71ad9039
```
