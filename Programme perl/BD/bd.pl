#!/usr/bin/perl 


#######################
if ( !open(OUT, ">>Fusion.txt") ) {
  print " Erreur d'ouverture de Fusion.txt \n"; 
  exit(0);
}

if ( !open(IN, "test.txt") ) {
	print " Erreur d'ouverture de test.txt \n"; 
	exit(0);	
}
$indent = 0;
while(<IN>) {
	#Incrémentation pour la clé primaire
	$indent++;
	#print OUT ("DEBUT\t- PU$indent \n");
	if($_ =~ /(.)*-/) {
		$ligne = $1;
		print ("INDENT : $indent");
		if($ligne = "PMID") {
			#On remplace par l'incrément
			$_ =~ s/PMID\s*-.*/PMID - $indent/;
			print OUT ("$_ \n");;
			#print OUT "LIGNE";
		} elsif ($ligne ="TI") {
			
		} elsif ($ligne = "AU") {
		
		} elsif ($ligne = "DP") {
		
		} elsif ($ligne = "LA") {
		
		} elsif ($ligne = "AB") {
		
		} elsif ($ligne = "OT" or $ligne = "MH") {
		
		} elsif ($ligne = "AD") {
		
		} else {
			$i = 2; #autre truc à ne pas afficher
		}
	} else {
		#ligne vide à afficher
		if(!($i=2)) {
			#on affiche la ligne
			print OUT ("$_ \n");
		}
	}
}

	#Titre - TI
	
	#Auteur - AU
	
	#DP -> DA
	
	#Langue - LA
	
	#AB
	
	#OT/MH
	
	#AD
	
	#if(@resultat = ($_ =~ m/PMID(.*)/g)) {
	#	foreach $ligne (@resultat) {
	#		print OUT "LIGNE : $ligne \n";
	#	}
	#}