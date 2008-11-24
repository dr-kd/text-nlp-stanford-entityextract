#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Text::NLP::Stanford::EntityExtract' );
}

diag( "Testing Text::NLP::Stanford::EntityExtract $Text::NLP::Stanford::EntityExtract::VERSION, Perl $], $^X" );
