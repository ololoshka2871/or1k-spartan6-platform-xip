#ifndef __MEM_MAP_H__
#define __MEM_MAP_H__

//-----------------------------------------------------------------
// Defines:
//-----------------------------------------------------------------
#define IO_BASE             0x12000000

//-----------------------------------------------------------------
// Macros:
//-----------------------------------------------------------------
#define REG8                (volatile unsigned char*)
#define REG16               (volatile unsigned short*)
#define REG32               (volatile unsigned int*)

//-----------------------------------------------------------------
// Peripheral Base Addresses
//-----------------------------------------------------------------
#define UART_BASE               (IO_BASE + 0x000)
#define TIMER_BASE              (IO_BASE + 0x100)
#define INTR_BASE               (IO_BASE + 0x200)
#define BOOT_SPI_BASE		(IO_BASE + 0x300)

//-----------------------------------------------------------------
// Interrupts
//-----------------------------------------------------------------
#define IRQ_UART_RX             0
#define IRQ_TIMER_SYSTICK       1
#define IRQ_TIMER_HIRES         2
#define IRQ_BOOT_SPI		3
#define IRQ_EXT_INT0            8

//-----------------------------------------------------------------
// Peripheral Registers
//-----------------------------------------------------------------

// UART
#define UART_USR            (*(REG32 (UART_BASE + 0x4)))
#define UART_UDR            (*(REG32 (UART_BASE + 0x8)))

// TIMER
#define TIMER_VAL           (*(REG32 (TIMER_BASE + 0x0)))
#define SYS_CLK_COUNT       (*(REG32 (TIMER_BASE + 0x4)))

// IRQ
#define IRQ_MASK            (*(REG32 (INTR_BASE + 0x00)))
#define IRQ_MASK_SET        (*(REG32 (INTR_BASE + 0x00)))
#define IRQ_MASK_CLR        (*(REG32 (INTR_BASE + 0x04)))
#define IRQ_STATUS          (*(REG32 (INTR_BASE + 0x08)))

// BOOT_SPI
#define BOOT_SPI_SPCR       (*(REG32 (BOOT_SPI_BASE + 0x00)))
#define BOOT_SPI_SPSR       (*(REG32 (BOOT_SPI_BASE + 0x01)))
#define BOOT_SPI_SPDR       (*(REG32 (BOOT_SPI_BASE + 0x02)))
#define BOOT_SPI_SPER       (*(REG32 (BOOT_SPI_BASE + 0x03)))
#define BOOT_SPI_CS_SEL     (*(REG32 (BOOT_SPI_BASE + 0x04)))

//-----------------------------------------------------------------
// pecial-Purpose Registers
//-----------------------------------------------------------------

// SR Register
#define SPR_SR                  (17)

// bits
#define SPR_SR_GIE              (1 << 2)
#define SPR_SR_ICACHE_FLUSH     (1 << 17)
#define SPR_SR_DCACHE_FLUSH     (1 << 18)

#endif 
