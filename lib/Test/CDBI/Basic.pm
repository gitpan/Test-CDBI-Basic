package Test::CDBI::Basic;

=head1 TITLE

Test::CDBI::Basic - Very basic testing of Class::DBI classes

=head1 DESCRIPTION

Allows for quick and dirty testing of Class::DBI classes

=head1 SYNOPSIS

	use strict;
	use warnings;

	use Test::More tests => 31;
	use Test::CDBI::Basic qw( test_class );
	use Some::DBI::Class;

	test_class( 'Sequins::DBI::Hit' );

=head1 INTRODUCTION

This module does something very simple that I find myself doing whenever
I write tests for Class::DBI subclasses. It reads in the class, tries to
create a new object, and then goes through the columns, attempting to assign
the value of 1 to every column. It doesn't check if the column was actually
updated. Basically then, it allows you to check your column definitions
match reality. It won't attempt to assign a value to any column set as a
primary column. It does this in the most naive way possible, and then tries
to delete the object created.

It makes a call to C<ok>, however that's defined in the calling class,
when an object was created, and once for every
column.

=head1 FUNCTIONS

=head2 test_class

Accepts a class name and an optional list of arguments to be treated like
a hash to pass to your class's C<create> method.

=head1 AUTHOR

Peter Sergeant - C<pete [a] clueball.com>	

=head1 LICENSE

As perl itself

=cut

# Magic module stuff

	use strict;
	use warnings;

	require Exporter;
	our @ISA = qw(Exporter);
	our @EXPORT_OK = qw( test_class );
	our $VERSION = '0.01';

	my @to_purge;

# The function itself

sub test_class {

	my ($class_name) = shift;
	my %attributes = @_;

	my ($parent_package) = caller();

	my %primaries = map { $_ => 1 } $class_name->primary_columns;
	
	my $item = $class_name->create( \%attributes );
	
	no strict 'refs';
	
	&{$parent_package . "::ok"}( $item, 'We created a ' . $class_name . ' object ok' );
	
	push( @to_purge, $item );

	for my $column ( $item->columns ) {

		if ( $primaries{ $column } ) {
		
			&{$parent_package . "::ok"}( 1, $class_name . '.' . $column . ' probably ok, as we created the object' );
		
		} else {

			$item->$column( 1 );
			$item->update;
			&{$parent_package . "::ok"}( $item->$column, $class_name . ".$column is editable" );
	
		}
	
	}
	
	$item->delete;	
	
}

END {

	for ( @to_purge ) {
	
		next if ref($_) eq 'Class::DBI::Object::Has::Been::Deleted';
		$_->delete;
	
	}

}

1;

