C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  test_inline_C_1_pl_7230.xs > test_inline_C_1_pl_7230.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- test_inline_C_1_pl_7230.xsc test_inline_C_1_pl_7230.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   test_inline_C_1_pl_7230.c
test_inline_C_1_pl_7230.xs: In function `c_test':
test_inline_C_1_pl_7230.xs:15: error: syntax error before '}' token
dmake.exe:  Error code 129, while making 'test_inline_C_1_pl_7230.o'
