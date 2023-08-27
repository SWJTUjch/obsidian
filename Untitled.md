JLink.exe -ExitOnError 1 -device R7FA4W3AH -Speed 4000 -IF SWD
loadbin D:\BLE\BLE_test\BLE_TEST_BM\ra\fsp\src\r_ble_usod\zsp_fw\VS_BLE.bin 0x10100200
