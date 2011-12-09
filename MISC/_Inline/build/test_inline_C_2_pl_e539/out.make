C:\Programme\perl\bin\perl.exe C:\Programme\perl\lib\ExtUtils\xsubpp  -typemap C:\Programme\perl\lib\ExtUtils\typemap  test_inline_C_2_pl_e539.xs > test_inline_C_2_pl_e539.xsc && C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "mv" -- test_inline_C_2_pl_e539.xsc test_inline_C_2_pl_e539.c
C:/PROGRA~1/perl/site/bin/gcc.exe -c  -IC:/perl5lib_mho/MISC 	-DNDEBUG -DWIN32 -D_CONSOLE -DNO_STRICT -DHAVE_DES_FCRYPT -DUSE_SITECUSTOMIZE -DPRIVLIB_LAST_IN_INC -DPERL_IMPLICIT_CONTEXT -DPERL_IMPLICIT_SYS -DUSE_PERLIO -DPERL_MSVCRT_READFIX -DHASATTRIBUTE -fno-strict-aliasing -mms-bitfields -O2 	  -DVERSION=\"0.00\" 	-DXS_VERSION=\"0.00\"  "-IC:\Programme\perl\lib\CORE"   test_inline_C_2_pl_e539.c
Running Mkbootstrap for test_inline_C_2_pl_e539 ()
C:\Programme\perl\bin\perl.exe -MExtUtils::Command -e "chmod" -- 644 test_inline_C_2_pl_e539.bs
C:\Programme\perl\bin\perl.exe -MExtUtils::Mksymlists \
     -e "Mksymlists('NAME'=>\"test_inline_C_2_pl_e539\", 'DLBASE' => 'test_inline_C_2_pl_e539', 'DL_FUNCS' => {  }, 'FUNCLIST' => [], 'IMPORTS' => {  }, 'DL_VARS' => []);"
Set up gcc environment - 3.4.5 (mingw-vista special r3)
dlltool --def test_inline_C_2_pl_e539.def --output-exp dll.exp
C:\PROGRA~1\perl\site\bin\g++.exe -o blib\arch\auto\test_inline_C_2_pl_e539\test_inline_C_2_pl_e539.dll -Wl,--base-file -Wl,dll.base -mdll -L"C:\Programme\perl\lib\CORE" test_inline_C_2_pl_e539.o -Wl,--image-base,0x2b0c0000  C:\Programme\perl\lib\CORE\perl510.lib -lkernel32 -luser32 -lgdi32 -lwinspool -lcomdlg32 -ladvapi32 -lshell32 -lole32 -loleaut32 -lnetapi32 -luuid -lws2_32 -lmpr -lwinmm -lversion -lodbc32 -lodbccp32 -lmsvcrt dll.exp
test_inline_C_2_pl_e539.o:test_inline_C_2_pl_e539.c:(.text+0x92): undefined reference to `SvPv'
collect2: ld returned 1 exit status
dmake.exe:  Error code 129, while making 'blib\arch\auto\test_inline_C_2_pl_e539\test_inline_C_2_pl_e539.dll'
