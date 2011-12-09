#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    void greet(SV* name1, ...) {
            Inline_Stack_Vars;
            int i; char j_str
            
            for (i = 0; i < Inline_Stack_Items; i++)
                 printf("Hello %s!\n", SvPV(Inline_Stack_Item(i), PL_na));
               
                
            Inline_Stack_Void;
                }


MODULE = ko_6_1_0_perllint_a94d	PACKAGE = main	

PROTOTYPES: DISABLE


void
greet (name1, ...)
	SV *	name1
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	greet(name1);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

