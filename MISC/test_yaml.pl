#!/usr/bin/perl -w
use strict;
use YAML;


my @liste = (['auftrag', 'teilsystem', 'datum'],
             [['Hpos', 'Bennennung', 'Laenge'],
              ['Naht1', 'Nahtlaenge1'],
              ['Naht2', 'Nahtlaenge2'],
            ],
              [['Hpos2', 'Bennennung2', 'Laenge2'],
              ['Naht1', 'Nahtlaenge1'],
              ['Naht2', 'Nahtlaenge2'],
              ],);



print Dump(@liste);



