###############################################################################
# Configuration
###############################################################################
# Target
TARGET ?= gdb_stub

# Memory Layout
MEMBASE ?= 0x10000000
MEMSIZE ?= 16383 # 2**14
MEMNAME ?= sram

###############################################################################
# Files
###############################################################################
INCLUDE_DIRS ?= 
OBJ = boot.o
OBJS = $(patsubst %.c,%.o,$(wildcard *.c))
OBJ+= $(OBJS)

###############################################################################
## Makefile
###############################################################################

# Tools
OR1K_TCHAIN ?= or1knd-elf
CC          = $(OR1K_TCHAIN)-gcc $(CFLAGS)
AS          = $(OR1K_TCHAIN)-as
LD          = $(OR1K_TCHAIN)-ld
OBJDUMP     = $(OR1K_TCHAIN)-objdump
OBJCOPY     = $(OR1K_TCHAIN)-objcopy

# Options
CFLAGS 	   	?=
CFLAGS	   	+= -Ttext $(MEMBASE) -Os -g -Wall -pipe -ffunction-sections -fdata-sections
CFLAGS     += -msoft-float
CFLAGS     += -msoft-div -msoft-mul -mno-ror -mno-cmov -mno-sext
CFLAGS	   	+= -nostartfiles -nodefaultlibs -nostdlib 
CFLAGS	   	+= -lgcc -L .
ASFLAGS     =
LDFLAGS     = -Wl,-gc-sections

LDSCRIPT	 = link.ld
CFLAGS 		+= -mno-delay -D__OR1K_NODELAY__ -D__OR1K__
ASFLAGS		+= -mno-delay -Wa,--defsym,__OR1K_NODELAY__=1
CFLAGS 		+= -T$(LDSCRIPT)

CFLAGS 		+= -I. $(INCLUDE_DIRS)

###############################################################################
# Rules
###############################################################################
all: $(TARGET).elf lst bin bootloader.hex
	
clean:
	-rm $(OBJ) *.map *.lst *.hex *.txt *.elf $(TARGET).bin

%.o : %.s
	$(CC) -c $(ASFLAGS) $< -o $@

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(TARGET).elf: $(OBJ) $(LDSCRIPT) makefile
	$(CC) $(LDFLAGS) $(LIBS) $(OBJ) -o $@
	
lst:  $(TARGET).lst

%.lst: $(TARGET).elf
	$(OBJDUMP) -h -d -S $< > $@

bin: $(TARGET).bin

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

bootloader.hex: $(TARGET).bin
	xxd -ps -c 4 $< > $@
