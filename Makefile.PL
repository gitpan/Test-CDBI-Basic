use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Test::CDBI::Basic',
    VERSION_FROM      => 'lib/Test/CDBI/Basic.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Test/CDBI/Basic.pm', # retrieve abstract from module
       AUTHOR         => 'Peter Sergeant <sheriff@>') : ()),
);
