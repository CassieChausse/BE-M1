#!/usr/bin/perl
use HTML::TokeParser;

#######################
if ( !open(OUT, ">>$ARGV[0]") ) {
  print " Erreur d'ouverture de $ARGV[0] \n"; 
  exit(0);
}

my $repertoire = 'C:\CASSIE\TOULOUSE\Cours SID\M1\BE M1\BE-M1\index2';
foreach my $fichier ( lister_fichiers( $repertoire, 1 ) ) { 
  if ( !open(IN, "$fichier") ) {
  #if ( !open(IN, "test.html") ) {
	print " Erreur d'ouverture de $fichier \n"; 
	exit(0);	
  }
  print OUT "------------------------------------------------------\n";
  print OUT "FICHIER : $fichier";
  #print OUT "\n"; # separateur de notices 
  $p = HTML::TokeParser->new("$fichier") || die "Can't open: $!";
  &parse_meta_tags;          # lecture des META TAGS.
  while(<IN>) {
	if(my @liste = ($_ =~ m@<article[^>]*>(.*)</article>@)) {
		#On a tout ce qui se trouve entre <article> et </article>
		#On va retirer toutes les balises
			foreach my $ligne (@liste) {
				$ligne =~ s/<[^<]*>/-/g;
				print OUT "\nAR : $ligne";
			}
		#close(OUT);
	} elsif (my @liste = ($_ =~ m@</ul><p><a href=.*>(.*)<p>&nbsp;</p>  @)) {
	#On va retirer toutes les balises
			foreach my $ligne (@liste) {
				$ligne =~ s/<[^<]*>/-/g;
				print OUT "\nAR : $ligne";
			}
		#close(OUT);
  }
  }
  print OUT "\n";
  close(IN);
}
close(OUT);

sub parse_meta_tags {
  &parse_title;            # lecture du Titre du document.
}

sub parse_title {
  if ($p->get_tag("title")) {
    local $title = $p->get_trimmed_text;  

    $title =~ s/Á|Â|À|Ã|Å|Ä/A/g;
    $title =~ s/â|á|à|å|ä/a/g;
    $title =~ s/ç/c/g;
    $title =~ s/Ç/C/g;
    $title =~ s/é|ê|è|ë/e/g;
    $title =~ s/É|Ê|È|Ë/E/g;
    $title =~ s/Í|Î|Ì|Ï/I/g;
    $title =~ s/í|î|ì|ï/i/g;
    $title =~ s/Ñ/N/g;
    $title =~ s/ñ/n/g;
    $title =~ s/Ó|Ô|Ò|Ø|Õ|Ö/O/g;
    $title =~ s/ó|ô|ò|ø|õ|ö/o/g;
    $title =~ s/Ú|Û|Ù|Ü/U/g;
    $title =~ s/ú|û|ù|ü/u/g; 
    $Data =~ s/
//g;
    print OUT "\nTI-: $title"; 
  }
}

close(IN);
#close(OUT);

#====================================================== 
# Nombre d'arguments : 1 ou 2 
# Argument(s)        : un répertoire et valeur 0 ou 1 
# Retourne           : Tableau de fichier (@fichiers) 
#====================================================== 
sub lister_fichiers { 
  my ( $repertoire, $recursivite ) = @_; 
  
  require Cwd; 
  require File::Spec; 
  
  my $cwd = Cwd::getcwd(); 
  
  # Recherche dans les sous-répertoires ou non 
  if ( ( not defined $recursivite ) || ( $recursivite != 1 ) ) { $recursivite = 0; } 
  
  # Verification répertoire 
  if ( not defined $repertoire ) { die "Aucun repertoire de specifie\n"; } 
  
  # Ouverture d'un répertoire 
  opendir my $fh_rep, $repertoire or die "impossible d'ouvrir le répertoire $repertoire\n"; 
  
  # Liste fichiers et répertoire sauf (. et ..) 
  my @fic_rep = grep { !/^\.\.?$/ } readdir $fh_rep; 
  
  # Fermeture du répertoire 
  closedir $fh_rep or die "Impossible de fermer le répertoire $repertoire\n"; 
  
  chdir $repertoire; 
  $repertoire = Cwd::getcwd(); 
  
  # On récupère tous les fichiers 
  my @fichiers; 
  foreach my $nom (@fic_rep) { 
    my $notre_fichier = File::Spec->catfile( $repertoire, $nom ); 
  
    if ( -f $notre_fichier ) { 
      push @fichiers, $notre_fichier; 
    } 
    elsif ( -d $notre_fichier and $recursivite == 1 ) { 
      push @fichiers, lister_fichiers($notre_fichier, $recursivite);    # recursivité 
    } 
  } 
  
  chdir $cwd; 
  
  return @fichiers; 
}



