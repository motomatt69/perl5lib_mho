C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  ko_6_1_0_perllint_39ae.xs > ko_6_1_0_perllint_39ae.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- ko_6_1_0_perllint_39ae.xsc ko_6_1_0_perllint_39ae.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   ko_6_1_0_perllint_39ae.c
ko_6_1_0_perllint_39ae.xs: In function `greet':
ko_6_1_0_perllint_39ae.xs:11: error: `j' undeclared (first use in this function)
ko_6_1_0_perllint_39ae.xs:11: error: (Each undeclared identifier is reported only once
ko_6_1_0_perllint_39ae.xs:11: error: for each function it appears in.)
ko_6_1_0_perllint_39ae.xs:11: error: invalid operands to binary *
dmake.exe:  Error code 129, while making 'ko_6_1_0_perllint_39ae.o'
