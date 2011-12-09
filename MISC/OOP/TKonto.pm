package TKonto;
use strict;

use strict;
 
# Konstruktor
sub new {
my ($inPkg, $inKontostand, $inDispo) = @_;
my $self = {
            'kontostand' => $inKontostand,
            'dispo'	=> $inDispo
            };
bless $self, $inPkg;
return $self;
}
   
   # Verändernde Methoden
   sub addiere {
    my ($inSelf, $inBetrag) = @_;
    $inSelf->{'kontostand'} += $inBetrag;
    }
  
     # Die Überweisung wird nur durchgeführt, wenn wir dadurch unseren
     # Dispo nicht überziehen.
     sub ueberweise {
        my ($inSelf, $inTo, $inBetrag) = @_;
        if ($inSelf->getKontostand() - $inBetrag >= $inSelf->getDispo()) {
            $inSelf->addiere (-$inBetrag);
            $inTo->addiere ($inBetrag);
            }
        }
   
      sub verzinse {
        my ($inSelf) = @_;
        
           	if ($inSelf->getKontostand() > 0) {
                    $inSelf->addiere ($inSelf->getKontostand() * TKonto::guthabenzinsen());
                    } else {
                    $inSelf->addiere ($inSelf->getKontostand() * TKonto::kreditzinsen());
                    }
                }
   
      # Lesende Methoden
      sub getKontostand {
        my ($inSelf) = @_;
        return $inSelf->{'kontostand'};
        }
      
         sub getDispo {
            my ($inSelf) = @_;
            return $inSelf->{'dispo'};
            }
   
      # Statische Methoden
      
         # 2 Prozent Guthabenzinsen
         sub guthabenzinsen {
            return 0.02;
            }
   
      # 9 Prozent Kreditzinsen
      sub kreditzinsen {
        return 0.09;
        }
   
   1;   
__END__



1;