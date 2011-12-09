#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    void greet(int x) {
    int z;
    Z = 4 * x;
      printf("Hello %d!\n", name);
    }

MODULE = ko_6_1_0_perllint_bf1a	PACKAGE = main	

PROTOTYPES: DISABLE


void
greet (x)
	int	x
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	greet(x);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

