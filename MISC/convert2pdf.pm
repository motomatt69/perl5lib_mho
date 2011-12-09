package MISC::convert2pdf;
# Comments: This script convert a printable file in a pdf-file using 
#           the com interface of PDFCreator.

use strict;
use Win32::OLE;
use File::Spec;
#use Cwd;

sub convert{
    my ($class, $inpath, $outpath) = @_;   

    #my @ins = File::Spec->splitdir($inpath);
    #my $infile = pop @ins;
    #my $indir = File::Spec->catdir(@ins);
    
    my @outs = File::Spec->splitdir($outpath);
    my $pdffile = pop @outs;
    my $pdfdir = File::Spec->catdir(@outs);
    #if (!@ARGV)
    #{
    # print "Syntax: perl $0 <Filename>";
    # exit
    #}
    
       
    my $PDFCreator = Win32::OLE->new("PDFCreator.clsPDFCreator", "cClose")
                                    || die "Could not start PDFCreator!";
     
    $PDFCreator->cStart("/NoProcessingAtStartup");
    
    my $PDFCreatorOptions = Win32::OLE->new("PDFCreator.clsPDFCreator")
                            || die "Could not get a PDFCreator options object!";
    
    $PDFCreatorOptions = $PDFCreator->{cOptions};
    
    #my $cdir = getcwd();
    #$cdir =~ s/\//\\/g;
    
    $PDFCreatorOptions->{UseAutosave} = 1;
    $PDFCreatorOptions->{UseAutosaveDirectory} = 1;
    $PDFCreatorOptions->{AutosaveFormat} = 0;                 # 0 = PDF
    my $DefaultPrinter = $PDFCreator->cDefaultPrinter();
    $PDFCreator->cDefaultPrinter("PDFCreator");
    $PDFCreator->cClearCache();
    
    #foreach my $ifname (@ARGV)
    
    #my ($file,$dir,$ext) = fileparse($infile, qr/\.[^.]*/);
    #if ($dir eq ".\\") { $dir = $cdir; $infile = $dir . "\\" . $ifname}
    
     $PDFCreatorOptions->{AutosaveDirectory} = $pdfdir;
     $PDFCreatorOptions->{AutosaveFilename} = $pdffile;
     $PDFCreatorOptions->{PDFDisallowPrinting} = 1;
     $PDFCreator->{cOptions} = $PDFCreatorOptions;
    
     if (!$PDFCreator->cIsPrintable($inpath))
     {
      print "Converting: $inpath\n\nAn error is occured: File '$inpath' is not printable!";
      exit;
     } 
    
     $PDFCreator->cPrintfile($inpath);
     
     until (($PDFCreator->{cCountOfPrintjobs} != 0) )
     {
      sleep(1);  # PDFCreator needs time for printing.
     }
    
     my $counter = 0;
     until (($PDFCreator->{cCountOfPrintjobs} == 0) || ($counter > 300))
     {
      if ($counter == 0)
      {
       $PDFCreator->{cPrinterStop} = 0;
      }
      $counter++;
      sleep(1);
     }
    
    
    $PDFCreator->cDefaultPrinter($DefaultPrinter);
    sleep(1);
    $PDFCreator->cClose();
    sleep(1);
    
    print "Ready";
}

1;