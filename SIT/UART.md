# Connection
- UART3_TXD <--> P200 <--> B11
- UART3_RXD <--> P201 <--> A11
- UART3_RTS <--> P202 <--> C11
- UART3_CTS <--> P203 <--> B10
- UART2_TXD <--> P104 <--> B8
- UART2_RXD <--> P105 <--> C8
- UART2_RTS <--> P106 <--> E6
- UART2_CTS <--> P107 <--> E5
- UART1_TXD <--> P108 <--> G7
- UART1_RXD <--> P109 <--> G6
- UART1_RTS <--> P110 <--> L7
- UART1_CTS <--> P111 <--> J7
- UART0_TXD <--> P204 <--> C10
- UART0_RXD <--> P205 <--> J9
- UART0_RTS <--> P206 <--> K9
- UART0_CTS <--> P207 <--> L9

# How to get the transfer time of UART?

- Open UART
```
p_uart->p_api->open(p_uart->p_ctrl, p_uart->p_cfg);
```
- Reset the send buffer and receive buffer
- 


_ERBFI_ : Enable Received Data Available Interrupt. This is used to enable/disable the generation of Received Data Available Interrupt and the Character Timeout Interrupt 'if in FIFO mode and FIFO's enabled'. These are the second highest priority interrupts.

_ETBET_ : Enable Transmit Holding Register Empty Interrupt. This is used to enable/disable the generation of Transmitter Holding Register Empty Interrupt. This is the third highest priority interrupt. (Used in transmit)

_ELSI_ : Enable Receiver Line Status Interrupt. This is used to enable/disable the generation of Receiver Line Status Interrupt. This is the highest priority interrupt.

_PTIME_ : Programmable THRE Interrupt Mode Enable. Writeable only when THRE_MODE_USER == Enabled, always readable. This is used to enable/disable the generation of THRE Interrupt. (Used in transmit)


# Console framework API structure

``` C
typedef struct st_terminal_api

{
/** @brief Initialize the terminal channel */
tmpl_err_t (* init) (void);
/** @brief Prints prompt string from menu, waits for input, parses input based on menu, and calls callback function
* if a command is identified. */
tmpl_err_t (* prompt)(tmpl_console_menu_t * p_menu);
/** @brief Looks for input string in menu, and calls callback function if found. */
tmpl_err_t (* parse)(tmpl_ctrl_t *p_tmpl_ctrl, tmpl_console_menu_t * p_menu);
/** @brief Reads data into the destination */
tmpl_err_t (* read)( void* pBufferIn, uint16_t BufferSize, uint16_t *pDataLen);
/** @brief The write API write data from buffer to the terminal */
tmpl_err_t (* write)( void* pBufferOut, uint16_t DataLen);
/** @brief The print API print msg to the terminal directly */
tmpl_err_t (* print)(char* msg, ...);
/** @brief The print API print msg to the terminal directly */
tmpl_err_t (* table_print)(table_info_t *table_info_ptr, uint32_t *test_data_ptr, bool result);
/** @brief Exit the terminal channel */
tmpl_err_t (* exit) (void);
/** @brief Stores version information in provided pointer. */
tmpl_err_t (* versionGet)(tmpl_version_t * const p_version);
} terminal_api_t;
```

``` C
typedef struct st_heartbeat_api
{
/** @brief Initialize the heartbeat with HAL driver and set the initialization timeout value */
tmpl_err_t (* init) (tmpl_heartbeat_cfg_t *p_cfg);
/** @brief Enable the heartbeat function */
tmpl_err_t (* enable) (void);
/** @brief Disable the heartbeat function */
tmpl_err_t (* disable) (void);
/** @brief Refresh the status of heartbeat to avoid timeout dead */
tmpl_err_t (* refresh) (void);
/** @brief Set the timeout value for heartbeat function */
tmpl_err_t (* timeout) (uint32_t time_out);
/** @brief Get current observe value of heartbeat for measurement */
tmpl_err_t (* observe) (tmpl_heartbeat_observe_t *p_observe);
/** @brief Get tick difference from observed value */
tmpl_err_t (* tickDiff) (tmpl_heartbeat_observe_t *p_observe_start, tmpl_heartbeat_observe_t *p_observe_end, uint64_t *diff);
/** @brief Stores version information in provided pointer. */
tmpl_err_t (* versionGet)(tmpl_version_t * const p_version);
} heartbeat_api_t;
```

```C
typedef struct st_report_api
{
/** @brief Initialize the report with verbose mode value and reset the command execute index */
tmpl_err_t (* init) (tmpl_report_cfg_t *p_cfg);
/** @brief Set verbose mode status, Enable or disable the verbose mode */
tmpl_err_t (* verboseCtrl) (tmpl_report_verbose_mode_t verboseMode);
/** @brief Print test result information with verbose control */
tmpl_err_t (* print) (char* msg, ...);
/** @brief Checking the test result value with criteria for pass or fail */
tmpl_err_t (* criteriaCheck) (uint8_t *funcName, int32_t *p_cmdArgint,
uint32_t resultValue, uint32_t criteria_min, uint32_t criteria_max,
uint32_t status);
/** @brief Generate the totally report information of project */
tmpl_err_t (* reportGen) (void);
/** @brief Stores version information in provided pointer. */
tmpl_err_t (* versionGet)(tmpl_version_t * const p_version);
} report_api_t;
```


# Initialization flow































