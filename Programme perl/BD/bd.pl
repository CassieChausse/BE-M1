#!/usr/bin/perl 


####################### BD PUBPSYCH #######################
if ( !open(OUT, ">>FusionPP.txt") ) {
  print " Erreur d'ouverture de FusionPP.txt \n"; 
  exit(0);
}

if ( !open(IN, "PP - Copie.txt") ) {
	print " Erreur d'ouverture de PP - Copie.txt \n"; 
	exit(0);	
}
$indent = 0;
while(<IN>) {
	#Incrémentation pour la clé primaire
	#print OUT ("DEBUT\t- PU$indent \n");
	if($_ =~ /Résultat:/) {
		$indent++;
		print OUT ("------------------------------------\n");
		print OUT ("PMID- PP$indent \n");
	} elsif ($_ =~ /TI:\s*(.*)/) {
		print OUT ("TI - $1 \n");
	} elsif ($_ =~ /AU:\s*(.*)/) {
		print OUT ("AU - $1 \n");
	} elsif ($_ =~ /PY:\s*(.*)/) {
		print OUT ("DA - $1 \n");
	} elsif ($_ =~ /LA:\s*(.*)/) {
		print OUT ("LA - $1 \n");
	} elsif ($_ =~ /ABHR:\s*(.*)/) {
		print OUT ("AB - $1 \n");
	} elsif ($_ =~ /CTEH:\s*(.*)/) {
		print OUT ("MC - $1 \n");
	} elsif ($_ =~ /CS:\s*(.*)/) {
		print OUT ("AD - $1 \n");
	} elsif ($_ =~ /COU:\s*(.*)/) {
		print OUT ("PY - $1 \n");
	} elsif ($_ =~ /EMAILO:\s*(.*)/) {
		print OUT ("EM - $1 \n");
	}
}

close(OUT);
close(IN);

####################### BD PQ #######################
# if ( !open(OUT, ">>FusionPQ.txt") ) {
  # print " Erreur d'ouverture de FusionPQ.txt \n"; 
  # exit(0);
# }

# if ( !open(IN, "PQ - Copie.txt") ) {
	# print " Erreur d'ouverture de PQ - Copie.txt \n"; 
	# exit(0);	
# }
# $indent = 0;
# while(<IN>) {
	##Incrémentation pour la clé primaire
	##print OUT ("DEBUT\t- PU$indent \n");
	##print OUT ("LIGNE : $_ \n");
	# if($_ =~ /Résumé:\s*(.*)/) {
		# $indent++;
		# print OUT ("------------------------------------\n");
		# print OUT ("PMID- PQ$indent \n");
		# print OUT ("AB - $1 \n");
	# } elsif ($_ =~ /Titre:\s*(.*)/) {
		# print OUT ("TI - $1 \n");
	# } elsif ($_ =~ /Auteur:\s*(.*)/) {
		# print OUT ("AU - $1 \n");
		# print OUT ("AD - $1 \n");
	# } elsif ($_ =~ /Date\sde\spublication:\s*(.*)/) {
		# print OUT ("DA - $1 \n");
	# } elsif ($_ =~ /Langue:\s*(.*)/) {
		# print OUT ("LA - $1 \n");
	# } elsif ($_ =~ /Sujet:\s*(.*)/) {
		# print OUT ("MC - $1 \n");
	# } elsif ($_ =~ /Identificateur.*:\s*(.*)/) {
		# print OUT ("MC - $1 \n");
	# } elsif ($_ =~ /Adresse\sde\scourriel\sde\sl\'auteur:\s*(.*)/) {
		# print OUT ("EM - $1 \n");
	# } elsif ($_ =~ /Âge:\s*(.*)/) {
		# print OUT ("AG - $1 \n");
	# }
# }

# close(OUT);
# close(IN);