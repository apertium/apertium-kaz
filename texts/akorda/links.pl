#!/usr/bin/perl

use LWP::Simple;
use HTML::LinkExtractor;
use Data::Dumper;

my $LX = new HTML::LinkExtractor();
my $counter = 0;

for (my $page=1; $page<=370; $page++)
{
	$content = get("http://akorda.kz/pda.php?r=page/allNews&category_id=127&language=en&Pages_page=$page");
	die "Couldn't get it!" unless defined $content;

	$LX->parse(\$content);

	for my $Link ( @{ $LX->links } )
	{
		if ($$Link{href} =~ /\/pda.php\?r=page\/view&sefname=page_.+&language=en/)
		{
			print "http://akorda.kz".$$Link{href}."\n";
			$counter++;
		}
	}
	print STDERR "...".$counter;
}

print STDERR "\n";
