C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  test_inline_C_1_pl_b680.xs > test_inline_C_1_pl_b680.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- test_inline_C_1_pl_b680.xsc test_inline_C_1_pl_b680.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   test_inline_C_1_pl_b680.c
test_inline_C_1_pl_b680.xs: In function `c_test':
test_inline_C_1_pl_b680.xs:11: error: syntax error before string constant
dmake.exe:  Error code 129, while making 'test_inline_C_1_pl_b680.o'
