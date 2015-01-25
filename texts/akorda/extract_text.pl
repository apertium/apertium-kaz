#!/usr/bin/perl

use HTML::TreeBuilder;
use IO::HTML;

my ($source_dir, $target_dir) = ($ARGV[0], $ARGV[1]) or die "Usage: extract_text.pl SOURCE-DIR TARGET-DIR\n";

my $NBSP = HTML::Entities::decode_entities('&nbsp;');

opendir(SOURCE_DIR, $source_dir);
@source_files = grep { $_ ne '.' and $_ ne '..' } readdir SOURCE_DIR;

my $counter = 0;

foreach $filename (@source_files) { 
	my $tree = HTML::TreeBuilder->new;
	
	#$filehandle = html_file("$source_dir/$filename");
	my ($filehandle, $encoding, $bom) = IO::HTML::html_file_and_encoding("$source_dir/$filename");
	
	$tree->parse_file($filehandle);
	open (TARGET_FILE, ">$target_dir/$filename");
	binmode TARGET_FILE, ":encoding($encoding)";

	if (my $h1 = $tree->look_down('_tag', 'h1'))
	{
		my $header = $h1->as_trimmed_text;
		$header =~ s/$NBSP//g;
		print TARGET_FILE $header;
	}

	if (my @paragraphs = $tree->look_down('_tag', 'p', 
		sub {
			$img = $_[0]->look_down('_tag', 'img');
			return 1 unless $img;
			return 0;
		}
	))
	{
		my $p;
		foreach $p (@paragraphs)
		{
			$para = $p->as_trimmed_text;
			$para =~ s/$NBSP//g;
			if ($para ne "") 
			{ 
				print TARGET_FILE "\n\n".$para; 
			}
		}
	}
	
	close(TARGET_FILE);
	$tree->delete;
	
	print STDERR "...".++$counter;
}

print STDERR "\n";

closedir(SOURCE_DIR);
