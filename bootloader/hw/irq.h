#ifndef __IRQ_H__
#define __IRQ_H__

#include <stdint.h>

#define ENTER_CRITICAL()        __or1k_disable_interrupts()
#define EXIT_CRITICAL()         __or1k_enable_interrupts()


typedef unsigned int* (*irq_handler)(unsigned int * registers);
typedef void (*isr_handler)(unsigned int * registers);

enum InterruptSources {
    IS_UART0 = 0,
    IS_TIMER_SYSTICK = 1,
    IS_TIMER_HIRES = 2,

    IS_Count = IS_TIMER_HIRES + 1
};

//-----------------------------------------------------------------
// Prototypes
//-----------------------------------------------------------------
void irq_enable(int interrupt);
void irq_disable(int interrupt);
void irq_acknowledge(int interrupt);
int irq_check(int interrupt);

irq_handler install_irq_global_handler(irq_handler handler);
void interrupts_init(void);

void setInterruptPriority(enum InterruptSources src, uint8_t new_prio);
isr_handler set_irq_handler(enum InterruptSources src, isr_handler handler);

void __or1k_disable_interrupts(void);
void __or1k_enable_interrupts(void);

#endif
