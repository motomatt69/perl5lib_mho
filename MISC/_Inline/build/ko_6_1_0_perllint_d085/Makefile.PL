use ExtUtils::MakeMaker;
my %options = %{
{
  'TYPEMAPS' => [
    'C:\\Programme\\perl\\lib\\ExtUtils\\typemap'
  ],
  'NAME' => 'ko_6_1_0_perllint_d085',
  'INC' => '-IC:/perl5lib_mho/MISC',
  'VERSION' => '0.00'
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }
