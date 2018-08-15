/*
    AVERTISSEMENT du 05/02/11 :
    après près de deux ans d'utilisation, je songe à revopir
    en profondeur cette extension(ette) pour en faire
    une vraie extension avec davantage de possibilités.
    Tout est susceptible de changer !
*/

// probabilitytree.asy - v. 1.1 - 19/04/09
// Extension destinée à dessiner un arbre de probabilités
// C'est une première version, non documentée, en phase de test.
// G. Marris

real DistVertEntreNoeuds = .5cm;
real DistHoriEntreNiveaux = 2cm;
real HauteurNoeudMinimale = .5cm;
pen  StyleEvenParDefaut = 1bp+black;
pen  StyleBackGrParDefaut = invisible;
pen  StyleProbParDefaut = black;
pen  StyleBrParDefaut = black;

struct Noeud {Noeud   parent;
              Noeud[] enfants;
              Label   evenement;
              Label   probabilite;
              pen     coul_pr;
              pen     coul_br;
              pair    lieu;
              frame   cadre;
              real    decalage_y;
}

Noeud addN( Noeud parent = null, 
            Label evenement = "", 
            pen[] evpen={StyleEvenParDefaut,StyleBackGrParDefaut},
            Label probabilite = null, 
            pen   prpen=StyleProbParDefaut,
            pen   brpen=StyleBrParDefaut)
{
  frame fr;
  Noeud nouvelenfant = new Noeud;
  if (evpen.length==1) evpen[1]=StyleBackGrParDefaut;
  label(fr,evenement,evpen[0]);
  roundbox(fr,
           xmargin=1mm, 
           Fill(evpen[1]));
  nouvelenfant.cadre = fr;
  nouvelenfant.probabilite = probabilite;
  nouvelenfant.coul_pr = prpen;
  nouvelenfant.coul_br = brpen;
  if( parent != null ) {
    nouvelenfant.parent = parent;
    parent.enfants.push( nouvelenfant );
  }
  return nouvelenfant;
}

real CalculHauteur( int niveau, Noeud noeud )
{
  real hauteurcadrenoeud=(max(noeud.cadre)-min(noeud.cadre)).y;
  if( noeud.enfants.length > 0 ) {
    real hauteur[] = new real[noeud.enfants.length];
    real H = 0;

    for( int i = 0; i < noeud.enfants.length; ++i ) {
      hauteur[i] = CalculHauteur(niveau+1, noeud.enfants[i] );
      noeud.enfants[i].lieu =(niveau*DistHoriEntreNiveaux, H-hauteur[i]/2);
      H -= hauteur[i]+DistVertEntreNoeuds;
    }
    real hauteurramifications = (sum(hauteur)
                                 +DistVertEntreNoeuds*(hauteur.length-1));
    for( int i = 0; i < noeud.enfants.length; ++i ) {
      noeud.enfants[i].decalage_y = hauteurramifications/2;
    }
    return max(hauteurcadrenoeud,sum(hauteur)
                                 +DistVertEntreNoeuds*(hauteur.length-1));
  }
  else {
    return max(hauteurcadrenoeud,HauteurNoeudMinimale);
  }
}
void TracerRecursivement( Noeud noeud, frame f )
{
  pair pos;
  if( noeud.parent != null )
    pos = (0, noeud.parent.lieu.y + noeud.decalage_y);
  else
    pos = (0, noeud.decalage_y);
  noeud.lieu += pos;

  noeud.cadre = shift(noeud.lieu)*noeud.cadre;
  
  if( noeud.parent != null ) {
    pair dirtrait=noeud.parent.lieu-noeud.lieu;
    path p = point(noeud.cadre,dirtrait)--point(noeud.parent.cadre,E);
    draw(f,p,noeud.coul_br); 
    if( noeud.probabilite != null ) {
        label(f,scale(.9)*noeud.probabilite,
                relpoint(p,.3),noeud.coul_pr,Fill(1,white));
    }
  }

  add( f, noeud.cadre );
  
  for( int i = 0; i < noeud.enfants.length; ++i )
    TracerRecursivement( noeud.enfants[i], f );
}
void TracerArbre( Noeud racine, pair pos=(0,0) )
{
  frame f;
  racine.lieu = (0,0);
  CalculHauteur( 1, racine );
  TracerRecursivement( racine, f );
  add(f,pos);
}
void Bernouilli( Label Succes="$S$", Label probS="$p$",
                 Label Echec="$\overline{S}$", Label probE="$q$",
                 int repet=2, pair pos=(0,0) )
{
  int n = 2^repet-1, j;
  Noeud[] N;
  N[0] = addN( );
  for (int i=1; i<=2*n; i+=2) {
        j=floor((i-1)/2);
        N[i] = addN( N[j], Succes, probS );
        N[i+1] = addN( N[j], Echec, probE );
  }
  TracerArbre( N[0], pos );
}
void GagnerAToutPrix( Label Succes="$G$", Label probS="$\frac{1}{2}$",
                      Label Echec="$P$", Label probE="$\frac{1}{2}$",
                      int repet=4, pair pos=(0,0) )
{
  int n = 2*repet;
  Noeud[] N;
  N[0] = addN( );
  for (int i=0; i<=repet; ++i) {
        N[2*i+1] = addN( N[2*i], Succes, probS );
        N[2*i+2] = addN( N[2*i], Echec, probE );
  }
  TracerArbre( N[0], pos );
}

pair operator cast(Noeud P)
{
  return P.lieu;
}
