
#include <stdarg.h>

int ee_printf(const char *fmt, ...)
{
  char buf[15*80],*p;
  va_list args;
  int n=0;

  va_start(args, fmt);
  ee_vsprintf(buf, fmt, args);
  va_end(args);

  gdb_putstr(buf);

  return n;
}
