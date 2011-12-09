C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  ko_6_1_0_perllint_6334.xs > ko_6_1_0_perllint_6334.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- ko_6_1_0_perllint_6334.xsc ko_6_1_0_perllint_6334.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   ko_6_1_0_perllint_6334.c
ko_6_1_0_perllint_6334.c: In function `c_test':
ko_6_1_0_perllint_6334.c:75: error: redefinition of parameter 'boot_ko_6_1_0_perllint_6334'
ko_6_1_0_perllint_6334.c:73: error: previous definition of 'boot_ko_6_1_0_perllint_6334' was here
ko_6_1_0_perllint_6334.c:75: error: syntax error before '{' token
ko_6_1_0_perllint_6334.c:77: error: parameter `sp' is initialized
ko_6_1_0_perllint_6334.c:77: error: parameter `ax' is initialized
ko_6_1_0_perllint_6334.c:77: error: parameter `mark' is initialized
ko_6_1_0_perllint_6334.c:77: error: parameter `items' is initialized
ko_6_1_0_perllint_6334.c:82: error: syntax error before '(' token
ko_6_1_0_perllint_6334.c:84: error: parameter `vn' is initialized
ko_6_1_0_perllint_6334.c:84: error: parameter `module' is initialized
ko_6_1_0_perllint_6334.c:84: error: syntax error before "if"
dmake.exe:  Error code 129, while making 'ko_6_1_0_perllint_6334.o'
