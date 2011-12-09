use strict;

#my @people = (qw(Sarathy Jan Sparky Murray Mike));
#greet(@people);

my @nums = (10, 20, 30, 40);

greet(@nums);

use Inline C =>q{
    void greet(SV* name1, ...) {
            Inline_Stack_Vars;
            int i; char* j_str;
            
            for (i = 0; i < Inline_Stack_Items; i++){
                 j_str = SvPV(Inline_Stack_Item(i), PL_na);
                 printf("Hello %s!\n", j_str);
                 }
               
                
            Inline_Stack_Void;
                }

}    

       

