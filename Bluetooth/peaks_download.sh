#!/bin/bash

# config .gitconfig
git config --global url.ssh://gerrit-spsd.verisilicon.com:29418/Renesas/.insteadof "git@pbgitap01.rea.renesas.com:"
git config --global url.http://mirror-spsd.verisilicon.com:8080/github/.insteadof "https://github.com/"
git config --global url.http://mirror-spsd.verisilicon.com:8080/github/aws/amazon-freertos.insteadof "git@github.com:renesas/amazon-freertos"


# git clone peaks
git clone --recursive -c submodule."ra/fsp/lib/r_ble".update=none \
-c submodule."ra/fsp/src/rm_ble_mesh/!third_party_source/crackle".update=none \
-c submodule."ra/fsp/lib/rm_ble_mesh/ethermind".update=none \
-c submodule."ra/fsp/src/r_sce_protected/crypto_procedures_protected".update=none \
-c submodule."ra/microsoft/azure-rtos/netxduo".update=none \
-c submodule."ra/aws/amazon-freertos".update=none \
-c submodule."ra/renesas/wireless/ryz012/r_ble_spp".update=none \
-c submodule."ra/segger/emwin".update=none \
-c submodule."test_files/aws_devicetester_freertos_linux".update=none \
-c submodule."ra/microsoft/embedded_wireless_framework".update=none \
-c submodule."scripts/svd_iodef_gen".update=none \
-c submodule."esp32-camera".update=none \
-c submodule."ra/renesas/zmod4xxx/libraries/iaq_2nd_gen".update=none \
-c submodule."ra/renesas/zmod4xxx/libraries/iaq_2nd_gen_ulp".update=none \
-c submodule."ra/renesas/zmod4xxx/libraries/oaq_2nd_gen".update=none \
-c submodule."ra/renesas/zmod4xxx/libraries/sulfur_odor".update=none \
-b PULSAR-110-pulsar-develop "ssh://gerrit-spsd.verisilicon.com:29418/Renesas/peaks/peaks"

