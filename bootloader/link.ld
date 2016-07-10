
MEMORY 
{ 
  sram (rwx) : ORIGIN = 0x10000000, LENGTH = 16384
}

ENTRY(__start)

SECTIONS
{
  .boot.text :
  {
      PROVIDE(_text_start = .);
      KEEP(*(.boot.*))	         /* boot code */
      KEEP(*(.text.gdb_stub))    /* gdb-stub code */
  } > sram

  .boot.rodata :
  {
     . = ALIGN(4);
     KEEP(*(.rodata.CSWTCH.99))
     KEEP(*(.rodata.gdb_stub))  /* gdb-stub data */
  } > sram

  .boot.bss :
  {
      . = ALIGN(4);
      PROVIDE(_bss_gdb_stub_start = .);
      KEEP(*(.bss.gdb_stub))     /* gdb-stub bss */
      . = ALIGN(4);
      PROVIDE(_bss_gdb_stub_end = .);
      . += 8;
  } > sram

  .text :
  {
    . = ALIGN(4);
    *(.text .text.*)		 /* remaining code */
    *(.rodata)			 /* read-only data (constants) */
    *(.rodata*)
    *(.rdata*)
    . = ALIGN(4);
    PROVIDE(_text_end = .);
  } > sram
  
  .data : 
  {   
    . = ALIGN(4);
    _data_start = .;
    
    *(.got.plt) *(.got)
    *(.shdata)
    *(.data .data.* .gnu.linkonce.d.*)
    . = ALIGN(16);
    . = ALIGN (8);
    *(.ram)
    *(.eh_frame)
    . = ALIGN (8);
    _edata = .;
    _data_end = .;
  } > sram
   
  .bss : 
  {
    . = ALIGN(4);
    PROVIDE(_bss_start = .);
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    PROVIDE(_bss_end = .);
    . += 8;

    __heap_start__ = .;
    end = __heap_start__;
    _end = end;
    __end = end;
    KEEP(*(.heap))
    __heap_end__ = .;
    __HeapLimit = __heap_end__;

    /* Allocate room for stack */
    .   =  ALIGN(8) ;
    .   += 1024 ;
    _sp =  . - 16;
  } > sram
}
