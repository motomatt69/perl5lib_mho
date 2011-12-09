C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  ko_6_1_0_perllint_2e04.xs > ko_6_1_0_perllint_2e04.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- ko_6_1_0_perllint_2e04.xsc ko_6_1_0_perllint_2e04.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   ko_6_1_0_perllint_2e04.c
ko_6_1_0_perllint_2e04.c:73: error: two or more data types in declaration of `boot_ko_6_1_0_perllint_2e04'
ko_6_1_0_perllint_2e04.c:75: error: syntax error before '{' token
ko_6_1_0_perllint_2e04.c:77: error: syntax error before ')' token
ko_6_1_0_perllint_2e04.c:77: error: initializer element is not constant
ko_6_1_0_perllint_2e04.c:77: error: initializer element is not constant
ko_6_1_0_perllint_2e04.c:77: error: `sp' undeclared here (not in a function)
ko_6_1_0_perllint_2e04.c:82: error: syntax error before "void"
ko_6_1_0_perllint_2e04.c:83: error: syntax error before "void"
ko_6_1_0_perllint_2e04.c:84: error: initializer element is not constant
ko_6_1_0_perllint_2e04.c:84: error: syntax error before "if"
ko_6_1_0_perllint_2e04.c:84: warning: passing arg 2 of `Perl_new_version' makes pointer from integer without a cast
ko_6_1_0_perllint_2e04.c:84: warning: initialization makes integer from pointer without a cast
ko_6_1_0_perllint_2e04.c:84: error: initializer element is not constant
ko_6_1_0_perllint_2e04.c:84: warning: data definition has no type or storage class
ko_6_1_0_perllint_2e04.c:84: error: syntax error before "if"
ko_6_1_0_perllint_2e04.c:90: error: syntax error before '(' token
dmake.exe:  Error code 129, while making 'ko_6_1_0_perllint_2e04.o'
