C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  test_inline_C_2_pl_b59a.xs > test_inline_C_2_pl_b59a.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- test_inline_C_2_pl_b59a.xsc test_inline_C_2_pl_b59a.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   test_inline_C_2_pl_b59a.c
test_inline_C_2_pl_b59a.xs: In function `greet':
test_inline_C_2_pl_b59a.xs:11: error: invalid operands to binary *
dmake.exe:  Error code 129, while making 'test_inline_C_2_pl_b59a.o'
