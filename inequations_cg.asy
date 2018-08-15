// v4 29/10/2011, Christophe Grospellier.

// INSTALLATION:
//   copier ce fichier dans le sous-répertoire $HOME/.asy
//   Move this file in the sub-directory $HOME/.asy

//CODE:

import graph;
import patterns;

int lsol=0, rsol=1;
real hHatch=.2*cm; // Demi-hauteur des hachures
real hBrack=.3*cm, wBrack=2*hBrack/3; // Demi-hauteur et largeur du crochet
real extrem, bornebis;

////////////////////////////////////////////////////////////////////////
// a="écriture LaTeX de la solution" , borne=borne de l'inéquation    //
// position=position du label (N par défaut)                          //
// dirsol=lsol (0) ou rsol : solutions à gauche ou à droite           //
// brack="]" ou "["                                                   //
// solcolor=couleur des solutions                                     //
// xMin et xMax=abscisses mini et maxi de l'axe                       //
// ticks=Ticks("%",Step=...,step=...) ou Noticks()                    //
// solutions=true ou false : écrire "solutions"                       //
// hach=true ou false : dessiner les hachures                         //
////////////////////////////////////////////////////////////////////////

// Place un crochet "où on veut"
void bracket(picture pic=currentpicture, Label L="", real a, pair pos=N, string sensc, pen p=currentpen){
	real sens;
	label(pic,Label(L,p),(a,0),3.5*pos);
	if (sensc=="]"){sens=-1;}
	else {sens=1;}
        pair hB=(0,hBrack), wB=(wBrack,0);
	pic.add(new void(frame f, transform t) {
		pair z=t*(a,0);
		draw(f,z-hB--z+hB,p);
		draw(f,z-hB--z-hB+sens*wB,p);
		draw(f,z+hB--z+hB+sens*wB,p);});
}


// Trace un intervalle
void interval(picture pic=currentpicture, Label L1="", real a1, pair pos1=N, string sensc1,
		Label L2="", real a2, pair pos2=N, string sensc2,
	      real xMin=min(a1,a2)-2.5, real xMax=max(a1,a2)+2.5,
	      ticks ticks=Ticks(), pen p=currentpen){
	xlimits(pic,min=xMin,max=xMax);
	xaxis(pic,Label("$x$",align=N),ticks,Arrow);
	bracket(pic,L1,a1,pos1,sensc1,p);
	bracket(pic,L2,a2,pos2,sensc2,p);
	draw(pic,(a1,0)--(a2,0),p);
}

// Trace des hachures "où on veut"
void hatching(picture pic=currentpicture,
		real mini, real maxi, real hHatching=2mm,
		string myHatch){
        pair hH=(0,hHatch);
	pic.add(new void(frame f, transform t) {
	pair m=t*(mini,0), M=t*(maxi,0);
	fill(f,m-hH--m+hH--M+hH--M-hH--cycle,pattern(myHatch));});
}


// Solutions d'inéquation
void solonaxis(picture pic=currentpicture,
	     string a="",
	     real borne,
	     pair position=N,	    
	     int dirsol,
	     string brack,
	     pen solcolor=currentpen,
	     real xMin=borne-3, real xMax=borne+3,
	     ticks ticks=Ticks(),
	     bool solutions=true,
	     bool hach=true)
{
// Tracé de l'axe // Possibilité de changer le repérage dans Ticks()
  xlimits(pic,min=xMin,max=xMax);
  xaxis(pic,Label("$x$",align=N),ticks,Arrow);
// Crochet
  bracket(pic, a, borne, position, brack, 1.5bp+solcolor);
// Solutions en couleur
  if (dirsol==0){extrem=xMin;
		bornebis=xMax;}
  else {extrem=xMax;
	bornebis=xMin;}
  draw(pic,(borne,0)--(extrem,0),1.5bp+solcolor);
// Écrire "solutions"
  if (solutions){
	label(pic,Label("\scriptsize solutions",solcolor),((borne+extrem)/2,0),2*N);}
// Définition de la hachure
  add("hach_cg",hatch(H=3mm,dir=NE,solcolor));
  if (hach){
	hatching(pic,borne,bornebis,"hach_cg");}
}

//
// solonaxis(pic,a,borne,position,dirsol,brack,solcolor=currentpen,
//	   xMin=borne-3,xMax=borne+3,ticks=Ticks(),
//	   solutions=true,hach=true)

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

// Solutions d'inéquations
void sol2onaxis(picture pic=currentpicture,
              string a1="",
	      real borne1,
	      pair pos1=N,    
	      int dirsol1,
	      string bracket1,
	      pen solcolor1=currentpen,
	      string a2="",
	      real borne2,	    
	      pair pos2=N,    
	      int dirsol2,
	      string bracket2,
	      pen solcolor2=currentpen,
	      real xMin=min(borne1,borne2)-2.5, real xMax=max(borne1,borne2)+2.5,
	      ticks ticks=Ticks(),
	      bool hach=true)
{
solonaxis(pic,a1,borne1,pos1,dirsol1,bracket1,solcolor1,xMin,xMax,ticks,solutions=false,hach);
// Crochet
bracket(pic,a2, borne2, pos2, bracket2, 1.5bp+solcolor2);
// Solutions en couleur
  if (dirsol2==0){draw(pic,(borne2,0)--(xMin,0),1.5bp+solcolor2);}
  else {draw(pic,(borne2,0)--(xMax,0),1.5bp+solcolor2);}
// Intervalle solution (solcolor=solcolor1+solcolor2)
  if (dirsol1==0 && dirsol2==0){
	draw(pic,(min(borne1,borne2),0)--(xMin,0),(1.5bp+solcolor1+solcolor2));
	}
  if (dirsol1!=0 && dirsol2!=0){
	draw(pic,(max(borne1,borne2),0)--(xMax,0),(1.5bp+solcolor1+solcolor2));
	}
  if (borne1<borne2){
	if (dirsol1!=0 && dirsol2==0){
		draw(pic,(borne1,0)--(borne2,0),(1.5bp+solcolor1+solcolor2));
		}
	}
  if (borne1>borne2){
	if (dirsol1==0 && dirsol2!=0){
		draw(pic,(borne2,0)--(borne1,0),(1.5bp+solcolor1+solcolor2));
		}
	}
// Définition de la hachure
  add("hachback_cg",hatch(H=3mm,dir=NW,solcolor2));
  real bornebis2;
  if (hach){
	if (dirsol2==0){bornebis2=xMax;}
	else {bornebis2=xMin;}
	hatching(pic,borne2,bornebis2,"hachback_cg");}
}

//
// sol2onaxis(pic,a1,borne1,pos1,dirsol1,bracket1,solcolor1=currentpen,
//	    a2,borne2,pos2,dirsol2,bracket2,solcolor2=currentpen,
//	    xMin=min(borne1,borne2)-2.5,xMax=max(borne1,borne2)+2.5,
//	    ticks=Ticks(),hach=true)

