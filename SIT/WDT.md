# wdt_timer_test
设置定时器0和1，timer0定时刷新WDT，timer1定时一段时间，目的是看在timer1定时的这段时间内是否触发了WDT。

# wdt_timer_test_all
测试不同WDT分频和定时时间的情况

## NMI和直接复位
NMI是触发一个不可屏蔽中断，然后执行对应的函数，对于一些需要保存数据或者实例中的只是记录时间的过程来说，不能直接复位，所以使用NMI。