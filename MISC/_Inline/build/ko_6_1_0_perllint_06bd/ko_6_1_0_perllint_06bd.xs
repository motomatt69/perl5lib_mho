#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    int c_test (){
        int x; int y; int z;
        for (x = 1; x <= 100; x++){
            for (y = 1; y <= max; y++){
                z = x + y;
            //    printf ("%d\n", max);
            }
        }
    }

MODULE = ko_6_1_0_perllint_06bd	PACKAGE = main	

PROTOTYPES: DISABLE


int
c_test ()

