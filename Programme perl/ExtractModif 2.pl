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

    $title =~ s/�|�|�|�|�|�/A/g;
    $title =~ s/�|�|�|�|�/a/g;
    $title =~ s/�/c/g;
    $title =~ s/�/C/g;
    $title =~ s/�|�|�|�/e/g;
    $title =~ s/�|�|�|�/E/g;
    $title =~ s/�|�|�|�/I/g;
    $title =~ s/�|�|�|�/i/g;
    $title =~ s/�/N/g;
    $title =~ s/�/n/g;
    $title =~ s/�|�|�|�|�|�/O/g;
    $title =~ s/�|�|�|�|�|�/o/g;
    $title =~ s/�|�|�|�/U/g;
    $title =~ s/�|�|�|�/u/g; 
    $Data =~ s/
//g;
    print OUT "\nTI-: $title"; 
  }
}

close(IN);
#close(OUT);

#====================================================== 
# Nombre d'arguments : 1 ou 2 
# Argument(s)        : un r�pertoire et valeur 0 ou 1 
# Retourne           : Tableau de fichier (@fichiers) 
#====================================================== 
sub lister_fichiers { 
  my ( $repertoire, $recursivite ) = @_; 
  
  require Cwd; 
  require File::Spec; 
  
  my $cwd = Cwd::getcwd(); 
  
  # Recherche dans les sous-r�pertoires ou non 
  if ( ( not defined $recursivite ) || ( $recursivite != 1 ) ) { $recursivite = 0; } 
  
  # Verification r�pertoire 
  if ( not defined $repertoire ) { die "Aucun repertoire de specifie\n"; } 
  
  # Ouverture d'un r�pertoire 
  opendir my $fh_rep, $repertoire or die "impossible d'ouvrir le r�pertoire $repertoire\n"; 
  
  # Liste fichiers et r�pertoire sauf (. et ..) 
  my @fic_rep = grep { !/^\.\.?$/ } readdir $fh_rep; 
  
  # Fermeture du r�pertoire 
  closedir $fh_rep or die "Impossible de fermer le r�pertoire $repertoire\n"; 
  
  chdir $repertoire; 
  $repertoire = Cwd::getcwd(); 
  
  # On r�cup�re tous les fichiers 
  my @fichiers; 
  foreach my $nom (@fic_rep) { 
    my $notre_fichier = File::Spec->catfile( $repertoire, $nom ); 
  
    if ( -f $notre_fichier ) { 
      push @fichiers, $notre_fichier; 
    } 
    elsif ( -d $notre_fichier and $recursivite == 1 ) { 
      push @fichiers, lister_fichiers($notre_fichier, $recursivite);    # recursivit� 
    } 
  } 
  
  chdir $cwd; 
  
  return @fichiers; 
}



