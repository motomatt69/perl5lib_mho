#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    int c_test (){
        int x; int y; int z;
        for (x = 1; x <= 100; x++){
            for (y = 1; y <= 100; y++){
                z = x + y;
                printf ("%d\n", z);
            }
        }
        return (z)
    }

MODULE = test_inline_C_1_pl_7230	PACKAGE = main	

PROTOTYPES: DISABLE


int
c_test ()

