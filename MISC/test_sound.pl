use strict;
use warnings;

use Win32::Sound;

#Win32::Sound::Play('SystemStart');

my $wav = "C:\\dummy\\do_it_now.wav";

Win32::Sound::Play($wav);#