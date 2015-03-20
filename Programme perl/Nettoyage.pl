#usr/bin/perl -w

use strict;

my %indexDirect;#variable globale
my %posting;

sub LireTexte{
	my($fichier)=@_;
	my $texte = do{
	local$/=undef;
	open my$fh,"<",$fichier
	or die "Le fichier $fichier ne peut être ouvert:$!";
	<$fh>;
	};
	return $texte;
}

sub Minuscule{
	my($fichier)=$_[0];
	return lc$fichier;
}

sub RemplacerPonctuation{
	my($fichier)=$_[0];
	$fichier=~ s/[,;:\'\"\!\%\+\*\-\^\|\/\\\.\?\(\)\[\]]/ /gi;
	$fichier=~ s/ \s+/ /g;
	$fichier=~ s/^\s+//;
	$fichier=~ s/ \s+$//;
	$fichier=~ s/é/e/g;
	$fichier=~ s/è/e/g;
	$fichier=~ s/à/a/g;
	$fichier=~ s/â/a/g;
	$fichier=~ s/î/i/g;
	$fichier=~ s/ç/c/g;
	$fichier=~ s/ù/u/g;
	$fichier=~ s/û/u/g;
	return $fichier;
}

sub EliminerMotsVides {
	my($fichier,@vide)=@_;
	foreach my $mot (@vide){
		$fichier=~ s/\b$mot\b//ig;
	}
	return $fichier;
}

sub Segmenter{ 
	my($fichier)=$_[0];
	my(@liste)=split(' ',$fichier);
	return @liste;
}

sub Troncaturer{
	my(@liste)=@_;
	my($ligne);
	foreach $ligne (@liste){
		$ligne=substr($ligne,0,7);
	}
	return @liste;
}

sub Frequence{
	my(@liste)=@_;
	my(%table);
	my($ligne);
	foreach $ligne (@liste){
		if ($table{$ligne}){
			$table{$ligne}++;
		}else{
			$table{$ligne}=1;
		}
	}
	return %table;
}

sub DirectIndexDocument{
	my($identifiant,%hashage)=@_;
	$indexDirect{$identifiant}=\%hashage;
	return %indexDirect;
}

sub InverseIndexDocument{
	my($identifiant,%hashage)=@_;
	my $cle;
	foreach $cle (keys(%hashage)){
	  if ($posting{$cle}){
	      $posting{$cle}{$identifiant}=$hashage{$cle};
	  }else{
	      my %hash;
	      $hash{$identifiant}=$hashage{$cle};
	      $posting{$cle}=\%hash;
	  }
	}
	return %posting;
}

sub IndexerDocument{
	my($idDoc,$chemin)=@_;
	my($texte)=&RemplacerPonctuation(&Minuscule(&LireTexte($chemin)));

	my(@motsVides)=qw(où a de à lors au aux aucuns aussi autre avant avec avoir bon car cette ce cela ces ceux chaque ci comme comment dans des du dedans dehors depuis deux devrait doit donc dos droite début elle elles en encore essai est et eu fait faites fois font force haut hors ici il ils je juste la le les leur là ma maintenant mais mes mine moins mon mot même ni nommés notre nous nouveaux ou où par parce parole pas personnes peut peu pièce plupart pour pourquoi quand que quel quelle quelles quels qui sa sans ses seulement si sien son sont sous soyez sujet sur ta tandis tellement tels tes ton tous tout trop très tu valeur voie voient vont votre vous vu ça étaient état étions été être l m s d du un une unes uns);

	$texte=&EliminerMotsVides($texte,@motsVides);
	my(@mots)=&Troncaturer(&Segmenter($texte));

	my(%hashage)=&Frequence(@mots);
	
	my (%hashage2)=&DirectIndexDocument($idDoc,%hashage);
	
	my (%post)=&InverseIndexDocument($idDoc,%hashage);

}	

sub Lister {
	my($chemin)=@_;
	opendir(DIR,$chemin);
	my @fichier=readdir(DIR);
	closedir(DIR);
	return @fichier;
}

sub EcrireIndexDirect{
	my($chemin)=@_;
	open FIC,">",$chemin
	or die "Le fichier $chemin ne peut être ouvert:$!";
	my $cle;
	my $cle2;
	foreach $cle (sort(keys(%indexDirect))){
	      foreach $cle2 (sort(keys($indexDirect{$cle}))){
		      print (FIC "$cle : $cle2 : $indexDirect{$cle}{$cle2};   \n");
	      }
	 }
	 close (FIC);
	
}

sub EcrireIndexInverse{
	my($chemin)=@_;
	open FIC,">",$chemin
	or die "Le fichier $chemin ne peut être ouvert:$!";
	my $cle;
	my $cle2;
	foreach $cle (sort(keys(%posting))){
	      foreach $cle2 (sort(keys($posting{$cle}))){
		      print (FIC "$cle : $cle2 : $posting{$cle}{$cle2};   \n");
	      }
	 }
	 close (FIC);
	
}

sub IndexerCollection{
	my($chemin)=@_;
	my @repertoire=&Lister("./documents/");
	my($i)=-1;
	foreach my $chemin(@repertoire){
		&IndexerDocument($i,"./documents/$chemin");
		$i++;
	}
}

sub main{
 
 	 &IndexerCollection("./test/");
 	 &EcrireIndexDirect("./index.txt");
 	 &EcrireIndexInverse("./posting.txt");
 	
} 
# 
# &main();

1;