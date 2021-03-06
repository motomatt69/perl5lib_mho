#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    void plus(SV* num1, ...) {
        Inline_Stack_Vars;
        int i;
        for(i = 0; i < Inline_Stack_Items; i++)
            printf("Hello %d!\n", SvPv(Inline_Stack_Item(i), PL_na));
            
            Inline_Stack_Void;
        
    }

MODULE = test_inline_C_2_pl_d5da	PACKAGE = main	

PROTOTYPES: DISABLE


void
plus (num1, ...)
	SV *	num1
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	plus(num1);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

