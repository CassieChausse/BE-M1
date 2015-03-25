#!/usr/bin/perl 

#Programme qui sert à fusionner les différentes BD en les mettant sous les même format
#A la fin il suffit de regrouper les trois fichiers .txt réponses dans un seul

####################### BD PUBPSYCH #######################
if ( !open(OUT, ">>POURTHIB2.txt") ) {
  print " Erreur d'ouverture de POURTHIB2.txt \n"; 
  exit(0);
}

if ( !open(IN, "testPubmed.txt") ) {
	print " Erreur d'ouverture de testPubmed.txt \n"; 
	exit(0);	
}
$MC = "";
$AB = "";
$TI = "";
$DA = "";
@MC = ();
# while(<IN>) {

	# if($_ =~ /MC -(.*)/) {
		# @MC[$indMC] = $1;
		# $indMC++;
	# } elsif ($_ =~ /AB -(.*)/) {
		# $AB = $1;
	# } elsif ($_ =~ /TI -(.*)/) {
		# $TI = $1;
	# } elsif ($_ =~ /DA -(.*)/) {
		# $DA = $1;
	# } elsif ($_ =~ /PMID-/) {
		# print OUT ("DIC - $AB * $TI * ");
		# foreach $MC (@MC) {
			# print OUT ("$MC ");
		# }
		# print OUT ("\nDA - $DA \n");
		# $MC = "";
		# $AB = "";
		# $TI = "";
		# $DA = "";
		# @MC = ();
		# print OUT ("\n----------------------------------------------\n");
	# }
# }

while(<IN>) {

	if($_ =~ /MC -(.*)/) {
		@MC[$indMC] = $1;
		$indMC++;
	} elsif ($_ =~ /AB -(.*)/) {
		$AB = $1;
	} elsif ($_ =~ /TI -(.*)/) {
		$TI = $1;
	} elsif ($_ =~ /DA -(.*)/) {
		$DA = $1;
	} elsif ($_ =~ /PMID-/) {
		print OUT ("DIC - $AB * $TI * ");
		foreach $MC (@MC) {
			print OUT ("$MC ");
		}
		print OUT ("\nDA - $DA \n");
		$MC = "";
		$AB = "";
		$TI = "";
		$DA = "";
		@MC = ();
		print OUT ("\n----------------------------------------------\n");
	}
}

close(OUT);
close(IN);