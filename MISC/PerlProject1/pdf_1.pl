#!/usr/bin/perl -w
use strict;
#Windows Kommandozeile
system '"C:\Programme\OpenOffice.org 3\program\soffice.exe" "macro:///Standard.Module1.Test(C:\test.odt)"';
#Unix Kommandozeile (ungetestet)
system '/opt/OpenOffice.org/program/soffice "macro:///Standard.Module1.Test(/home/danny/Desktop/Test/test.sxw)"'; 