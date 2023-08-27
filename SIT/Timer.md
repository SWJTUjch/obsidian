# RTC Basic Knowledge
There is a register TCNT inside the timer. At the beginning of timing, we will put a total count value (for example, 300) into the TCNT register, and then every clock cycle (assumed to be 1ms) the value in TCNT will be automatically decremented by 1 (hardware automatically completes, no need for CPU software to intervene), until TCNT is reduced to 0, TCNT will trigger the timer interrupt. In this way, the timing is 300ms.
Note: The value reloaded in the count register should be the count _value -1_. For example, it needs to count 2 clock cycles, starting from 0 when the interrupt was generated in the last cycle. 0 - 1 - 0 has gone through two clock cycles in total, and an interrupt is generated when it reaches 0.

# Hardware resource
The SoC has two timers, which are 16-bit and 32-bit respectively. The timers has three count down modes. Each counter counts from the load value down to zero. Each counter has its own interrupt. The count value is always readily readable by software.
Each timer has a channel, channel 0 - 4 is 16-bits timer,  5 - 9 is 32-bits timer, need no frequency division.
Since 16-bits timer is easy to overflow, setted interval is short, therefore, it support frequency division, and have prescale registers. Such as divide the source clock by four, which means the count register will decrease after four clock cycles but not one. But 32-bits timer register is large, so it's not easy to overflow.


# Test module
- self test
	- initialize the timer configure
	- open the timer
	- test if timer status normal after open timer
		- test if timer is _TIMER_STATE_STOPPED_ before start timer
		- test if timer is _TIMER_STATE_COUNTING_ after start timer
		- test if counter is decrease after start timer
		- test if timer is  _TIMER_STATE_STOPPED_ after stop timer
		- test if counter continue count after stop timer
	- test if timer infomation normal
		- reset
		- period set
		- get information
			- direction is counting down
			- period be set successfully
			- check timer frequency
	- test call back api
		- set call back function
		- reset timer (timer has been initialized before, so don't need initialize)
		- stop timer (make sure thecall backe function is setted)
		- start timer
		- wait for the interrupt

- gpt_negative_test
	- open twice
	- close twice
	- start timer when timer is closed
- gpt_16_test: singal test need test period mode and one-shot
- gpt_32_test
- gpt_16_avg_test: avg_test only test period mode
- gpt_32_avg_test

# Measure time

- open RTC and set calendar if _loop > 1_
- select test mode (period or one-shot) according to the loop number 
- initialize timer(select source clock divider and the ISR according to channel number)
- open timer
- start timer
- observe _start_value_
- loop to calculate average time (once interrupt is triggered, _g_timer_test_cycle_end_counter_ will be set, and then stop the inner-loop)
- if _loop > 1_, get calendar time and calculate the diff between the RTC time
- close RTC






