#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    void plus(SV* num, ...) {
        Inline_Stack_Vars;
        int i;
        for(i = 0; i < Inline_Stack_Items; i++)
            printf("Hello %d!\n", SvPv(Inline_Stack_Item(i), PL_na));
            
            Inline_Stack_Void;
        
    }

MODULE = test_inline_C_2_pl_e539	PACKAGE = main	

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

