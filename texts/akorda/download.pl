#!/usr/bin/perl

#use LWP::Simple;

my $url, $i = 1, $command, $filename, $lang;

while ($url = <STDIN>)
{
	chop($url);
	$url =~ /sefname=(.+)&language=(\w+)/;
	$filename = $1;
	$lang = $2;

	$command = `wget -O $filename.$lang '$url' 2>log.txt`;
	print $command;

	print STDERR "...$i";
	$i++;
}

print STDERR "\n";
