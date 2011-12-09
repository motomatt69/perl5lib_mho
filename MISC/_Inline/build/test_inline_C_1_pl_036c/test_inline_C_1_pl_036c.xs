#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    void c_test (int max){
        int x; int y; int z;
        for (x = 1; x <= max; x++){
            for (y = 1; y <= max; y++){
                z = x + y;
                printf "%d\n", z
            }
        }
    }

MODULE = test_inline_C_1_pl_036c	PACKAGE = main	

PROTOTYPES: DISABLE


void
c_test (max)
	int	max
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	c_test(max);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

