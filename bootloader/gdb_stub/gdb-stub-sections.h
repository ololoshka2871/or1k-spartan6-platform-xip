#ifndef GDBSTUBSECTIONS_H
#define GDBSTUBSECTIONS_H

#ifdef _OWN_BOOTLOADER_SECTIONS
#define GDB_STUB_SECTION_RODATA	__attribute__((section (".rodata.gdb_stub")))
#define GDB_STUB_SECTION_TEXT	__attribute__((section (".text.gdb_stub")))
#define GDB_STUB_SECTION_BSS	__attribute__((section (".bss.gdb_stub")))
#else
#define GDB_STUB_SECTION_RODATA
#define GDB_STUB_SECTION_TEXT
#define GDB_STUB_SECTION_BSS
#endif

#endif // GDBSTUBSECTIONS_H
