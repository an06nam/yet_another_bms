#include "stm32f4xx.h"
#include "stm32f4xx_ll_bus.h"
#include "stm32f4xx_ll_gpio.h"
#include "stm32f4xx_ll_rcc.h"
#include "system_stm32f4xx.h"
#include <stdint.h>

static volatile uint32_t ms_ticks;
void SysTic_Handler(void){ms_ticks++;}
static void delay_ms(uint32_t ms){
  uint32_t end = ms_ticks + ms;
  while (ms_ticks < end) { __WFI(); }
}

int main(){
  SystemInit();
  SysTick_Config(SystemCoreClock / 1000U);

  LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_GPIOA);

  LL_GPIO_SetPinMode(GPIOA, LL_GPIO_PIN_5, LL_GPIO_MODE_OUTPUT);
  LL_GPIO_SetPinOutputType(GPIOA, LL_GPIO_PIN_5, LL_GPIO_OUTPUT_PUSHPULL);
  LL_GPIO_SetPinSpeed(GPIOA, LL_GPIO_PIN_5, LL_GPIO_SPEED_FREQ_LOW);
  LL_GPIO_SetPinPull(GPIOA, LL_GPIO_PIN_5, LL_GPIO_PULL_NO);

  while (1) {
    LL_GPIO_TogglePin(GPIOA, LL_GPIO_PIN_5);
    delay_ms(500);
  }

  return 0;
}
