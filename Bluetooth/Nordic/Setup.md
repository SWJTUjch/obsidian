# Windows
- Download and install nRF Command Line Tools according to your computer platform. URL:https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools/Download?lang=en#infotabs
- Download and install nRF Connect for Desktop. URL:https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-Desktop/Download#infotabs
- Install Toolchain Manager and Bluetooth Low Energy in  nRF Connect for Desktop. If Toolchain Manager can't install the lastest verison you can choose older one.
- Enter Toolchain Manager and install the lastest nRF Connect SDK, click the right arrow, then choose open bash.
- Input below commands
```shell
west init -m https://gitee.com/minhua_ai/sdk-nrf --mr gitee_mirror
west update
```
The second command may need long time and have some fatal errors because of network problem. You need to repeat this command until output without any fatal error.
# Linux
