#ifndef __GDB_H__
#define __GDB_H__

#include "gdb-stub-sections.h"

//-----------------------------------------------------------------
// Prototypes:
//-----------------------------------------------------------------
void          GDB_STUB_SECTION_TEXT gdb_main(void);
unsigned int* GDB_STUB_SECTION_TEXT gdb_exception(unsigned int *registers,
                                                  unsigned int reason);

#endif
