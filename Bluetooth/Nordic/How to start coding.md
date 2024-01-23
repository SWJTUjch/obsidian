
- UART have 3 work mode: loop, interrupt and DMA
	- If you want to use uart loop mode, choose project->ACTIONS->nRF Kconfig GUI->search "UART API"-> choose "Asynchronous UART API"->Apply->save to file.
	- If you want to use uart interrupt mode, select "UART interrupt support" in nRF Kconfig GUI.