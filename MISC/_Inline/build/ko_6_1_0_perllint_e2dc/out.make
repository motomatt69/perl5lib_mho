C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  ko_6_1_0_perllint_e2dc.xs > ko_6_1_0_perllint_e2dc.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- ko_6_1_0_perllint_e2dc.xsc ko_6_1_0_perllint_e2dc.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   ko_6_1_0_perllint_e2dc.c
ko_6_1_0_perllint_e2dc.xs: In function `c_test':
ko_6_1_0_perllint_e2dc.xs:8: error: syntax error before "for"
ko_6_1_0_perllint_e2dc.xs:8: error: syntax error before ')' token
ko_6_1_0_perllint_e2dc.xs:9: error: `y' undeclared (first use in this function)
ko_6_1_0_perllint_e2dc.xs:9: error: (Each undeclared identifier is reported only once
ko_6_1_0_perllint_e2dc.xs:9: error: for each function it appears in.)
ko_6_1_0_perllint_e2dc.xs:9: error: syntax error before ')' token
dmake.exe:  Error code 129, while making 'ko_6_1_0_perllint_e2dc.o'
