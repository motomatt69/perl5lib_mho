C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  ko_6_1_0_perllint_34ed.xs > ko_6_1_0_perllint_34ed.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- ko_6_1_0_perllint_34ed.xsc ko_6_1_0_perllint_34ed.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   ko_6_1_0_perllint_34ed.c
ko_6_1_0_perllint_34ed.xs: In function `c_test':
ko_6_1_0_perllint_34ed.xs:7: error: syntax error before "int"
ko_6_1_0_perllint_34ed.xs:10: error: `z' undeclared (first use in this function)
ko_6_1_0_perllint_34ed.xs:10: error: (Each undeclared identifier is reported only once
ko_6_1_0_perllint_34ed.xs:10: error: for each function it appears in.)
ko_6_1_0_perllint_34ed.xs:12: error: syntax error before string constant
dmake.exe:  Error code 129, while making 'ko_6_1_0_perllint_34ed.o'
