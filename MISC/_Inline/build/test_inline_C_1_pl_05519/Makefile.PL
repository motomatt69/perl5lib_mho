use ExtUtils::MakeMaker;
my %options = %{
{
  'TYPEMAPS' => [
    'C:\\Perl64\\lib\\ExtUtils\\typemap'
  ],
  'NAME' => 'test_inline_C_1_pl_05519',
  'INC' => '-IC:/perl5lib_mho/MISC',
  'VERSION' => '0.00'
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }
