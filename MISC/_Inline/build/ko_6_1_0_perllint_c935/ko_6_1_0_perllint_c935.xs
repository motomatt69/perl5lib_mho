#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"

    int c_test (int m){
        int x; int y; int z;
        for (x = 1; x <= 100; x++){
            for (y = 1; y <= 100; y++){
                z = x + y;
        //        printf ("%d\n", z);
        //    }
        //}
        
        printf ("max: %d\n\n", m);
        return;
        //return (z);
    }

MODULE = ko_6_1_0_perllint_c935	PACKAGE = main	

PROTOTYPES: DISABLE


int
c_test (m)
	int	m

