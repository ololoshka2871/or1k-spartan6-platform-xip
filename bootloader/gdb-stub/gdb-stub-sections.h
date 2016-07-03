#ifndef GDBSTUBSECTIONS_H
#define GDBSTUBSECTIONS_H

#define GDB_STUB_SECTION_RODATA	__attribute__((section (".rodata.gdb_stub")))
#define GDB_STUB_SECTION_TEXT	__attribute__((section (".text.gdb_stub")))
#define GDB_STUB_SECTION_BSS	__attribute__((section (".bss.gdb_stub")))

#endif // GDBSTUBSECTIONS_H
