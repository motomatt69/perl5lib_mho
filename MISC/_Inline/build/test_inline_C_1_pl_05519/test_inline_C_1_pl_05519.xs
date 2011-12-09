#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    int c_test (int m){
        int x; int y; int z;
        for (x = 1; x <= m; x++){
            for (y = 1; y <= m; y++){
                z = x + y;
                //printf ("%d\n", z);
            }
        }
        
        //printf ("max: %d\n\n", m);
        //return;
        return (z);
    }

MODULE = test_inline_C_1_pl_05519	PACKAGE = main	

PROTOTYPES: DISABLE


int
c_test (m)
	int	m

