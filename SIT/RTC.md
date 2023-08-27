This wiki is to record RTC SIT basic knowledge
# RTC Basic Knowledge
RTC is Real Time Clock, which describes the time by the format: such as _xx_ year _xx_ month _xx_ day _x_ hour _x_ minute _x_ second. The time is recorded by some registers in the RTC, RTC is a device integrated into the SoC, and has its own crystal oscillator (generally is 32.768kHz) as the source of the timer. In order to record time continuously when out of power, RTC has a separate battery powered.
RTC has two clock sources XOSC(external crystal, also called SUBCLK) and ROSC(internal oscillator, also called LOCO), and use ROSC by default. Generally speaking, under the LOCO source, the RTC timing is more accurate, the timing error is less than 10%, while under SUBCLK source, the timing error is about 15%


# Test API
[[RTC.canvas|RTC]]
- initalize_rtc_cfg: need to reconfigure p_rtc->p_cfg, maybe need to change the address latter.
- 
```C
const rtc_api_t g_rtc_on_rtc_usod =
{
.open = R_RTC_USOD_Open,
.close = R_RTC_USOD_Close,
.calendarTimeGet = R_RTC_USOD_CalendarTimeGet,
.calendarTimeSet = R_RTC_USOD_CalendarTimeSet,
.calendarAlarmGet = R_RTC_USOD_CalendarAlarmGet,
.calendarAlarmSet = R_RTC_USOD_CalendarAlarmSet,
.periodicIrqRateSet = R_RTC_USOD_PeriodicIrqRateSet,
.infoGet = R_RTC_USOD_InfoGet,
.errorAdjustmentSet = R_RTC_USOD_ErrorAdjustmentSet,
.callbackSet = R_RTC_USOD_CallbackSet,
};
```
# Test module
- negative test: In order to test whether the code can get the right result when operator a invalid action.
	- open twice
		- initialize RTC
		- open RTC for the first time
		- open RTC again (shoule return _FSP_ERR_ALREADY_OPEN_)
		- close RTC
	- close twice
		- initialize RTC
		- close RTC for the first time
		- close RTC again (should return _FSP_ERR_NOT_OPEN_)
	- set /get calendar time before opening the instance
		- set RTC calandar and should return _FSP_ERR_NOT_OPEN_
		- close RTC and should return _FSP_ERR_NOT_OPEN_
		- get RTC calandar and should return _FSP_ERR_NOT_OPEN_
		- close RTC and should return _FSP_ERR_NOT_OPEN_
	- set invalid RTC time
		- initialize RTC
		- open RTC
		- set a invalid RTC calandar and should return _FSP_ERR_INVALID_ARGUMENT_
		- close RTC
- post_date_setget_test
	- get the frequency of the system clock
	- set and get RTC data in a loop
		- initialize the RTC configuraction if it hasn't initialized.
		- initialize timer configuraction.
		- open RTC and GPT(timer)
		- set RTC calendar
		- start timer
		- get RTC calendar in a loop until the current calendar is same with the setted
		- get timer status
		- calculate the time: _g_gpt_count_sum_ is added when the interrupt of timer is triggered. _period_counts_ is a const number of timer, counter is _Timer n Load Current Value Register_
		- close RTC and GPT
	- print test result
- post_alarm_setget_test
	- get the frequency of a system clock
	- set and get RTC data in a loop
		- initialize the RTC if it hasn't initialized.
		- initialize timer
		- open RTC and GPT
		- set RTC calendar
		- set alarm
		- start timer
		- get alarm and test if the alarm is same with setted alarm (we set enable the alarm based on a match of the seconds field, so when the calendar reaches the alarm time, the get_alarm.sec_match would be true. We get alarm immediately after setting, so sec_match is must be _False_)
		- wait for the alarm interrupt triggered, in the ISR, _g_rtc_alarm_counter_ will increase, so just detect weather this data is changed. 
		- get timer status
		- calculate the time: _g_gpt_count_sum_ is added when the interrupt of timer is triggered. _period_counts_ is a const number of timer, counter is _Timer n Load Current Value Register_
		- close RTC and GPT
	- print result
- post_date_setget (same as _rtc_date_setget_)
- post_alarm_setget (same as _rtc_alarm_setget_)
- post_clk_src: change _g_rtc_cfg.clock_source_ according to the input.
- post_reset_cfg: just initialize RTC


- How to calculate the elapsed time.
	- elapsed time = (g_gpt_counter * period_counts + (period_counts - gpt.status.counter)) / CLK
		- _g_gpt_counter_ is the triggered number of timer interrupt, this is a _volatile_ type number, and it will be incremented by 1 in the ISR. 
		- _period_count_ is the counting number of a GPT clock cycle. This number will change per _1/CLK_ second.
		- _gpt.status.counter_ is the current data in the timer count regisiter, which initial number is  _period_counts_ and a interrupt will be triggered when it decreased to 0, so the data of _gpt.status.counter_ is the remaining count since last triggered interrupt. Therefore, _(period_counts - gpt.status.counter)_ is the elapsed time since last triggered interrupt.
		- _CLK_ is the frequency of current GPT source clock.


# Questions
- 177 line: if opening rtc failed but ==timer== successful
- 370 line: not complited?
- minate of expire time is defined, what if test a time over 60 seconds?






