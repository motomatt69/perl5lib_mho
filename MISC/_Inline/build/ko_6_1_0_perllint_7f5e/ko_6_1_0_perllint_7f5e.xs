#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    void plus(SV* num, ...) {
    Inline_Stack_Vars;
    int i;
    z = 4 * x;
      printf("Hello %d!\n", z);
    }

MODULE = ko_6_1_0_perllint_7f5e	PACKAGE = main	

PROTOTYPES: DISABLE


void
plus (num, ...)
	SV *	num
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	plus(num);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

