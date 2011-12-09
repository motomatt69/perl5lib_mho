C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  ko_6_1_0_perllint_3f20.xs > ko_6_1_0_perllint_3f20.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- ko_6_1_0_perllint_3f20.xsc ko_6_1_0_perllint_3f20.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   ko_6_1_0_perllint_3f20.c
ko_6_1_0_perllint_3f20.xs: In function `plus':
ko_6_1_0_perllint_3f20.xs:6: error: parameter name omitted
ko_6_1_0_perllint_3f20.xs:8: error: `x' undeclared (first use in this function)
ko_6_1_0_perllint_3f20.xs:8: error: (Each undeclared identifier is reported only once
ko_6_1_0_perllint_3f20.xs:8: error: for each function it appears in.)
dmake.exe:  Error code 129, while making 'ko_6_1_0_perllint_3f20.o'
