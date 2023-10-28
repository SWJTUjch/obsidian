```C
typedef struct st_ble_abs_periodic_advertising_parameter
{
    ble_abs_non_connectable_advertising_parameter_t advertising_parameter;
    uint8_t * p_periodic_advertising_data;
    uint16_t periodic_advertising_interval = (1000 / 1.25);
    uint16_t periodic_advertising_data_length;
} ble_abs_periodic_advertising_parameter_t;
typedef struct st_ble_abs_non_connectable_advertising_parameter
{
    ble_device_address_t * p_peer_address = {0};
    uint8_t * p_advertising_data;
    uint32_t advertising_interval = (1000 / 0.625);
    uint16_t advertising_duration;
    uint16_t advertising_data_length;
    uint8_t advertising_channel_map = BLE_GAP_ADV_CH_ALL;
    uint8_t own_bluetooth_address_type = BLE_GAP_ADDR_RAND;
    uint8_t own_bluetooth_address[6] = {0}; 
    uint8_t primary_advertising_phy = BLE_GAP_ADV_PHY_1M;
    uint8_t secondary_advertising_phy = BLE_GAP_ADV_PHY_1M;
} ble_abs_non_connectable_advertising_parameter_t;
```