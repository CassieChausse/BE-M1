#!/usr/bin/perl -w
use strict;

opendir (DIR,'.') || die ('Erreur Open Dir');
my @fic = readdir(DIR);
foreach my $nom (@fic) {
	if(-d $nom && index($nom,".")==0) { 
		printf ("%s \n",$nom);
	} else {
		#On regarde s'il y a un fichier index.htlm
		if($nom eq "index.html") {
			print("CA MARCHE\n\n");
		}
	}
}
