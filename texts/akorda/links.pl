#!/usr/bin/perl

use LWP::Simple;
use HTML::LinkExtractor;
use Data::Dumper;

my $LX = new HTML::LinkExtractor();
my $counter = 0;

for (my $page=1; $page<=391; $page++)
{
	$content = get("http://akorda.kz/pda.php/en/allNews?category_id=88&Pages_page=$page");
	die "Couldn't get it!" unless defined $content;

	$LX->parse(\$content);

	for my $Link ( @{ $LX->links } )
	{
		if ($$Link{href} =~ /\/pda.php\/en\/page\/page_.+/)
		{
			print "http://akorda.kz".$$Link{href}."\n";
			$counter++;
		}
	}
	print STDERR "...".$counter;
}

print STDERR "\n";
