#!/usr/bin/perl 


####################### BD PUBPSYCH #######################
if ( !open(OUT, ">>FusionPP.txt") ) {
  print " Erreur d'ouverture de FusionPP.txt \n"; 
  exit(0);
}

if ( !open(IN, "test.txt") ) {
	print " Erreur d'ouverture de test.txt \n"; 
	exit(0);	
}
$indent = 0;
while(<IN>) {
	#Incrémentation pour la clé primaire
	#print OUT ("DEBUT\t- PU$indent \n");
	if($_ =~ /Résultat:/) {
		$indent++;
		print OUT ("------------------------------------\n");
		print OUT ("PMID : $indent \n");
	} elsif ($_ =~ /ID:/) {
		print OUT ("$_ \n");
	} elsif ($_ =~ /TI:/) {
		print OUT ("$_ \n");
	} elsif ($_ =~ /CTEH:\s*(.*)/) {
		print OUT ("CTECH : $1 \n");
	}
}

close(OUT);
close(IN);

####################### BD PQ #######################
if ( !open(OUT, ">>FusionPQ.txt") ) {
  print " Erreur d'ouverture de FusionPQ.txt \n"; 
  exit(0);
}

if ( !open(IN, "test.txt") ) {
	print " Erreur d'ouverture de test.txt \n"; 
	exit(0);	
}
$indent = 0;
while(<IN>) {
	#Incrémentation pour la clé primaire
	#print OUT ("DEBUT\t- PU$indent \n");
	#print OUT ("LIGNE : $_ \n");
	if($_ =~ /Résumé:/) {
		$indent++;
		print OUT ("------------------------------------\n");
		print OUT ("PMID : $indent \n");
	} elsif ($_ =~ /Titre:/) {
		print OUT ("$_ \n");
	} elsif ($_ =~ /Lieu:/) {
		print OUT ("$_ \n");
	} elsif ($_ =~ /Langue:\s*(.*)/) {
		print OUT ("CTECH : $1 \n");
	}
}