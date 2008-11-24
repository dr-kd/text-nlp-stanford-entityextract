#!/usr/bin/env perl

use Test::More tests => 4;
use YAML;

BEGIN {
	use_ok( 'Text::NLP::Stanford::EntityExtract' );
}

diag( "Testing Text::NLP::Stanford::EntityExtract $Text::NLP::Stanford::EntityExtract::VERSION, Perl $], $^X" );

my $ner = Text::NLP::Stanford::EntityExtract->new;
ok($ner->server, 'got the server ok');
my @txt;

{local $/ = "\n\n";
 @txt = <DATA>;
}
my @res = $ner->get_entities(@txt);

ok(scalar(@res), 'Defined result.  A silly test, because the NLP ER recogniser is probably non-deterministic');

my $tagged_text = "blah/O blah/O Gwyneth/PERSON Paltrow/PERSON to/O the/O controversial/O Jewish-based/MISC faith/O that/O she/O follows/O ./O Now/O she/O is/O attempting/O ,/O for/O a/O second/O time/O ,/O to/O persuade/O Britney/LOCATION to/O follow/O suit/O ,/O reports/O said/O ./O Bruce/PERSON Lee/PERSON said/O from/O his/O home/O in/O Outer/LOCATION Mongolia/LOCATION ./O There/O is/O a/O question/O that/O Lord/PERSON Lucan/PERSON may/O have/O returned/O from/O the/O Chinese/LOCATION Mainland/LOCATION ./O Test/O a/O three/O word/O entity/O Location/LOCATION Location/LOCATION Location/LOCATION ./O";

$data = {
          'LOCATION' =>
              [ [ 'Britney', 26 ],
                [ 'Outer', 41, [ 'Mongolia', 42 ], ],
                [ 'Chinese', 56, [ 'Mainland', 57 ], ],
                [ 'Location', 64, [ 'Location', 65 ], [ 'Location', 66 ], ],
            ],
          'O' => [ [ 'blah', 1, [ 'blah', 2 ] ], [ 'to', 5, [ 'the', 6 ], [ 'controversial', 7 ] ], [ 'faith', 9, [ 'that', 10 ], [ 'she', 11 ], [ 'follows', 12 ], [ '.', 13 ], [ 'Now', 14 ], [ 'she', 15 ], [ 'is', 16 ], [ 'attempting', 17 ], [ ',', 18 ], [ 'for', 19 ], [ 'a', 20 ], [ 'second', 21 ], [ 'time', 22 ], [ ',', 23 ], [ 'to', 24 ], [ 'persuade', 25 ] ], [ 'to', 27, [ 'follow', 28 ], [ 'suit', 29 ], [ ',', 30 ], [ 'reports', 31 ], [ 'said', 32 ], [ '.', 33 ] ], [ 'said', 36, [ 'from', 37 ], [ 'his', 38 ], [ 'home', 39 ], [ 'in', 40 ] ], [ '.', 43, [ 'There', 44 ], [ 'is', 45 ], [ 'a', 46 ], [ 'question', 47 ], [ 'that', 48 ] ], [ 'may', 51, [ 'have', 52 ], [ 'returned', 53 ], [ 'from', 54 ], [ 'the', 55 ] ], [ '.', 58, [ 'Test', 59 ], [ 'a', 60 ], [ 'three', 61 ], [ 'word', 62 ], [ 'entity', 63 ] ], [ '.', 67 ] ],
          'PERSON' => [ [ 'Gwyneth', 3, [ 'Paltrow', 4 ] ],
                        [ 'Bruce', 34, [ 'Lee', 35 ] ],
                        [ 'Lord', 49, [ 'Lucan', 50 ] ] ],
          'MISC' => [ [ 'Jewish-based', 8 ] ]
      };

is_deeply($ner->entities_list($tagged_text), $data, "got expected taglist");


__DATA__
With her divorce settled, pop diva Madonna is focusing into converting more A-list stars to kabbalah, and her latest target is troubled singer Britney Spears.

The 50-year-old has already converted actress Gwyneth Paltrow to the controversial Jewish-based faith that she follows. Now she is attempting, for a second time, to persuade Britney to follow suit, reports said.

Madonna's friendship with Spears ended when the troubled singer announced after the birth of her second son, Jayden James: "I no longer study kabbalah. My baby is my religion."

But once again Madonna has rekindled her friendship with Spears.

"Madonna is determined she can get Spears back into kabbalah. She has offered her a suite of rooms at her apartment in New York and has told her that she is her surrogate mother. Spears used to wear the red kabbalah bracelet and read the books Madonna gave her and she is thinking about giving it another chance."

However, Spears' spokesman neither confirmed or denied the news.

"Spears wouldn t really comment on that, it s just a case of wait and see what happens," said the spokesperson.

Madonna also apparently plans to take her new friend, baseball star Alex Rodriguez, and Spears to Malawi next year in the hope they will make donations to the kabbalah centre she has set up there.
