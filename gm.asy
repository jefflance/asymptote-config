// gm.asy - Un fourre-tout de fonctions (récentes ou anciennes) pour Asymptote.
//
// Dernière modification : 04/07/15 pour l'ajout d'une ancienne fonction cote3D(...) 
//                                  proposée sur le forum le 10/04/10.

import stats;
import geometry;
import graph;
import three;

///////////////////////////////////////////////////////////
////////// STATISTIQUES
///////////////////////////////////////////////////////////
//
// Remarque de février 2012 : ce qui suit est amené à disparaitre
// Une extension gm_stats devrait voir le jour avant la fin 2012.
// Tout sera réécrit depuis une feuille blanche... 
// ... mais si cela peut dépanner jusque là.
//
// Rappel de la histogramm défini dans stats.asy :
// void histogram(picture pic=currentpicture, real[] bins, real[] count,
               // real low=-infinity,
               // pen fillpen=nullpen, pen drawpen=nullpen, bool bars=false,
                // Label legend="", real markersize=legendmarkersize)

// Une version perso (avec un e à la fin), plus adaptée pour faire 
// des histogrammes pour un de math de lycée :
void histogramme(picture pic=currentpicture,
                 real[] tabxi,   // les xi définissants les classes
                 real[] tabni,   // les effectifs (ou fréquence) par classe.
                 bool bars=true,
                 pen p1=lightgray,
                 pen p2=.8bp+blue,
                 string libellecaractere="Valeurs du caract\`ere",
                 real minaxe=min(tabxi),
                 real maxaxe=max(tabxi),
                 real uniteaxe=(maxaxe-minaxe)/4,
                 string libelleunite="",
                 bool afficherUniteAire=true,
                 bool valeurUniteAire=true,
                 bool frequence=false,
                 bool pourcent=false,
                 real uniteaire=sum(tabni)/100){
        real uniteairetempo;
        if(frequence==false) uniteairetempo=uniteaire;
        if(frequence==true && pourcent==false) {
                  if(uniteaire>=1) uniteaire=uniteaire/100;
                  uniteairetempo=uniteaire*sum(tabni);
                  }
        if(frequence==true && pourcent==true) {
                  uniteairetempo=uniteaire*sum(tabni)/100;
                  }
        // Une variable utile pour déterminer la plus petite amplitude :
        real largeurunite=abs(tabxi[1]-tabxi[0]);
        // ... et une autre pour le numéro de classe correspondant :
        int iclasse=0; 
        // Calcul des hauteurs (et de la plus petite amplitude de classe) :
        real[] tabhi;
        for(int i=0; i < tabni.length; ++i){
          tabhi[i]=tabni[i]/(tabxi[i+1]-tabxi[i]); 
          if (largeurunite>abs(tabxi[i+1]-tabxi[i])) {
                        largeurunite=abs(tabxi[i+1]-tabxi[i]);
                        iclasse=i;
                }
        }
        // Hauteur du rectangle le plus haut pour placer l'unité au dessus.
        real hauteurmaxi=max(tabhi);
        // Calcul de la hauteur à donner au rectangle unité d'aire
        real hauteurunite=(uniteairetempo/tabni[iclasse])*tabhi[iclasse];

        int nbrlignes = ceil(hauteurmaxi/hauteurunite);
        for(int k=0; k<=nbrlignes; ++k){
            draw((minaxe,k*hauteurunite)--(maxaxe,k*hauteurunite),.5bp+gray);
        }
        for(int k=0; k<=((maxaxe-minaxe)/largeurunite); ++k){
            draw((minaxe+k*largeurunite,0)--(minaxe+k*largeurunite,nbrlignes*hauteurunite),.5bp+gray);
        }
        // Tracé de l'histogramme
        histogram(tabxi,tabhi,low=0,bars=bars,p1,p2);
        // Tracé de l'unité d'aire et son étiquette
        if(afficherUniteAire){
            filldraw(shift(truepoint(N+W))*box((0,0),(largeurunite,hauteurunite)),p1,p2);
            if(valeurUniteAire)
                label(libelleunite+(string) uniteaire+(pourcent==true ? "\%": ""),truepoint(N+W)+(largeurunite,-hauteurunite/2),E);
        }    
        // Ajout de l'axe gradué
        xaxis(libellecaractere, Bottom, minaxe,maxaxe,
              RightTicks(Label(currentpen+fontsize(6)),
                  Step=uniteaxe),above=true);
}

/////// bam et multibam pour des diagrammes en boite.

void bam(real[] xi, real h=1, real dh=0, bool lab=true, real Step=1){
  xi=sort(xi);
  real n=xi.length;
  real xmin=min(xi),
       q1= (floor(.25*n)==.25*n) ? xi[floor(.25*n)-1] : xi[floor(.25*n)],
       me= (n%2==0) ? (xi[floor(n/2)-1]+xi[floor(n/2)])/2 : xi[floor((n+1)/2)-1],
       q3= (floor(.75*n)==.75*n) ? xi[floor(.75*n)-1] : xi[floor(.75*n)],
       xmax=max(xi);
  xaxis(xmin,xmax,Ticks(Step=Step,Size=2));
  draw(box((q1,1+dh),(q3,1+dh+h)));
  draw((me,1+dh)--(me,1+dh+h));
  real hm=(1+dh+1+dh+h)/2;
  draw((xmin,hm)--(q1,hm)^^(q3,hm)--(xmax,hm));
  draw((xmin,hm-.1)--(xmin,hm+.1)^^(xmax,hm-.1)--(xmax,hm+.1));
  draw((xmin,0)--(xmin,hm)^^(q1,0)--(q1,hm)^^(me,0)--(me,hm)^^(q3,0)--(q3,hm)
        ^^(xmax,0)--(xmax,hm),linetype("4 4"));
  if(lab){
       label("$X_{min}$",(xmin,hm),S,UnFill());
       label("$Q_1$",(q1,hm-h/2),S,UnFill());
       label("$M$",(me,hm-h/2),S,UnFill());
       label("$Q_3$",(q3,hm-h/2),S,UnFill());
       label("$X_{max}$",(xmax,hm),S,UnFill());
  }     
}

picture bam0(real[] xi, real larg=1, 
             bool  comment_b=false, 
             bool  titre_b =false, 
             Label titre_l ="", 
             pair  titre_pos=max(xi), 
             align titre_dir=NoAlign,
             pen stylo=currentpen, pen backgr=nullpen
             ){
    picture pic;
    xi=sort(xi);
    real n=xi.length;
    real xmin=min(xi),
    q1= (floor(.25*n)==.25*n) ? xi[floor(.25*n)-1] : xi[floor(.25*n)],
    me= (n%2==0) ? (xi[floor(n/2)-1]+xi[floor(n/2)])/2 : xi[floor((n+1)/2)-1],
    q3= (floor(.75*n)==.75*n) ? xi[floor(.75*n)-1] : xi[floor(.75*n)],
    xmax=max(xi);
    filldraw(pic,box((q1,-larg/2),(q3,larg/2)),backgr,stylo);
    draw(pic,(me,-larg/2)--(me,larg/2),stylo);
    draw(pic,(xmin,0)--(q1,0)^^(q3,0)--(xmax,0),stylo);
    draw(pic,(xmin,-.1)--(xmin,.1)^^(xmax,-.1)--(xmax,.1),stylo);
    if(titre_b) label(pic,titre_l,titre_pos,titre_dir);
    if(comment_b){
        label(pic,"$X_{min}$",(xmin,0),S,UnFill());
        label(pic,"$Q_1$",(q1,-larg/2),S,UnFill());
        label(pic,"$M$",(me,-larg/2),S,UnFill());
        label(pic,"$Q_3$",(q3,-larg/2),S,UnFill());
        label(pic,"$X_{max}$",(xmax,0),S,UnFill());
    }
    return pic;  
}

void multibam(picture pic=currentpicture,
              real[][] ij,
              real[]  larg  =new real[], 
              real[]  esp   =new real[], 
              bool    tit_b =false, 
              Label[] tit   =new Label[],
              align[] tit_d =new align[],
              pen[]   sty   =new pen[],
              pen[]   bkg   =new pen[],
              real Step=0, real step=0, real xmargin=0,
              bool vertical=false,
              bool twoaxis=false){
    picture pict;
    int n=ij.length;
    if(larg.length==0)larg.push(1);
    if(esp.length==0) esp.push(.5);
    while(larg.length<n) larg.push(larg[larg.length-1]);
    while(esp.length<n+1)esp.push(esp[esp.length-1]);
    while(tit.length<n)  tit.push("");
    while(tit_d.length<n) tit_d.push((vertical)?plain.W:plain.E);
    while(sty.length<n)  sty.push(currentpen);
    while(bkg.length<n)  bkg.push(nullpen);
    real[] espa=new real[n+1];
    for(int k=0; k<n; ++k){
        espa[k]=((k!=0)?espa[k-1]+larg[k-1]/2:0)+esp[k]+larg[k]/2;
        add(pict,shift(0,espa[k])*bam0(
                               ij[k],
                               larg      = larg[k],
                               titre_b   = false,
                               titre_l   = tit[k],
                               titre_dir = tit_d[k],
                               stylo     = sty[k],
                               backgr    = bkg[k])
        );
    }
    espa[n]=espa[n-1]+larg[n-1]/2+esp[n];
    if(vertical){
        add(pic,reflect(Oy)*rotate(90)*pict);
        addMargins(pic,0,xmargin);
        xlimits(pic,0,espa[n]);
        ylimits(pic,min(ij)-xmargin,max(ij)+xmargin);
        yaxis(pic,BottomTop,
              Ticks("%",Step=Step,step=step,extend=true,.2bp+dashed));
        yaxis(pic,Left,Ticks(Step=Step,step=step,Size=2,size=1,pTick=.7bp+blue,ptick=black));
        if(twoaxis) yaxis(pic,Right,Ticks(Step=Step,step=step,Size=2,size=1,pTick=.7bp+blue,ptick=black));
        if(tit_b) for(int k=0; k<n; ++k)
                      label(pic,tit[k],(espa[k],min(ij)-xmargin),plain.S);
    } else {
        add(pic,pict);
        addMargins(pic,xmargin);
        ylimits(pic,0,espa[n]);
        xlimits(pic,min(ij)-xmargin,max(ij)+xmargin);
        xaxis(pic,LeftRight,
              Ticks("%",Step=Step,step=step,extend=true,.2bp+dashed));
        xaxis(pic,Bottom,Ticks(Step=Step,step=step,Size=2,size=1,pTick=.7bp+blue,ptick=black));
        if(twoaxis) xaxis(pic,Top,Ticks(Step=Step,step=step,Size=2,size=1,pTick=.7bp+blue,ptick=black));
        if(tit_b) for(int k=0; k<n; ++k)
                  label(pic,tit[k],(max(ij)+xmargin,espa[k]),plain.E);
    }
}

void diabandes(real X, real Y, 
               real ymin, real ymax, real ystep, 
               real tickwidth, string yformat, 
               Label LX, Label LY, Label[] LLX, 
               real[] height,
               pen p=nullpen){
    draw((0,0)--(0,Y),EndArrow);
    draw((0,0)--(X,0),EndArrow);
    label(LX,(X,0),plain.SE,fontsize(9));
    label(LY,(0,Y),plain.N,fontsize(9));
    real yscale=Y/(ymax+ystep);
    for(real y=ymin; y<ymax; y+=ystep) { 
        draw((-tickwidth,yscale*y)--(0,yscale*y)); 
        label(format(yformat,y),(-tickwidth,yscale*y),plain.W,fontsize(9));
    }
    int n=LLX.length;
    real xscale=X/(2*n+2);
    for(int i=0;i<n;++i) { 
        real x=xscale*(2*i+1);
        path P=(x,0)--(x,height[i]*yscale)--(x+xscale,height[i]*yscale)--(x+xscale,0)--cycle;
        fill(P,p);
        draw(P);
        label(LLX[i],(x+xscale/2),plain.S,fontsize(10));
    }
    for(int i=0;i<n;++i) 
        draw((0,height[i]*yscale)--(X,height[i]*yscale),dashed);
}

//////////////////////////////////////////////////////////////////
/// TRACER UNE COURBE AVEC V.I. 
//////////////////////////////////////////////////////////////////

guide[] graphgm(picture pic=currentpicture, real f(real), real a, real b,
              int n=ngraph, real T(real)=identity,
              bool3 cond(real), interpolate join=operator --)
{
  if(T == identity)
    return graph(join,cond)(new pair(real x) {
        return (x,pic.scale.y.T(f(pic.scale.x.Tinv(x))));},
      pic.scale.x.T(a),pic.scale.x.T(b),n);
  else
    return graph(join,cond)(new pair(real x) {
        return Scale(pic,(T(x),f(T(x))));},
      a,b,n);
}

//////////////////////////////////////////////////////////////////
/// SIMILITUDES
/// - simili_Ckphi(point C, real k, real phi)
///   si sont connus : centre, rapport et angle
/// - simili_ABCD(point A, point B, point C, point D)
///   si sont connues les images C et D de deux points A et B.
//////////////////////////////////////////////////////////////////

transform simili_Ckphi(point C, real k, real phi){
   return rotate(phi,C)*scale(k,C);
}
transform simili_ABCD(point A, point B, point C, point D){
   point a=(D-C)/(B-A), b=C-a*A, centre=b/(1-a);
   real rapport=abs(a), angle=degrees(a);
   return simili_Ckphi(centre,rapport,angle);
}

//////////////////////////////////////////////////////////////////
///
/// 3D : le nom des fonctions parlent d'elles-même.
///
//////////////////////////////////////////////////////////////////
projection cavaliereX(real k=.5, real angle=45)
{
  transform3 t={{-k*Cos(angle),1,0,0},
                {-k*Sin(angle),0,1,0},
                {1,0,0,-1},
                {0,0,0,1}};
  return projection((1,Cos(angle)^2,1-Cos(angle)^2),normal=(1,0,0),
  new transformation(triple,triple,triple) { return transformation(t);});
}
projection cavaliereX=cavaliereX();
projection cavaliereYZ=cavaliereX();

projection cavaliereY(real k=.5, real angle=45)
{
  transform3 t={{1,k*Cos(angle),0,0},
                {0,k*Sin(angle),1,0},
                {0,-1,0,-1},
                {0,0,0,1}};
  return projection((Cos(angle)^2,-1,1-Cos(angle)^2),normal=(0,-1,0),
  new transformation(triple,triple,triple) { return transformation(t);});
}
projection cavaliereY=cavaliereY();
projection cavaliereXZ=cavaliereY();

projection cavaliereZ(real k=.5, real angle=45)
{
  transform3 t={{1,0,-k*Cos(angle),0},
                {0,1,-k*Sin(angle),0},
                {0,0,1,-1},
                {0,0,0,1}};
  return projection((Cos(angle)^2,1-Cos(angle)^2,1),up=(0,1,0),normal=(0,0,1),
  new transformation(triple,triple,triple) { return transformation(t);});
}
projection cavaliereZ=cavaliereZ();
projection cavaliereXY=cavaliereZ();


//////////////////////////////////////////////////////////////////
/////// 
///////  Inspirée par la définition de la fonction distance(...)
///////  que l'on trouve dans l'extension geometry,
///////  une fonction qui permet d'indiquer une distance entre deux triples :
/////// 
//////////////////////////////////////////////////////////////////

void cote3D(picture pic=currentpicture, Label L="", triple A, triple B, 
            triple v=O, real offset=1cm,
            pen p=currentpen, pen joinpen=dotted, arrowbar3 arrow=Arrows3){
  triple A=A, B=B, vAB=B-A;
  path3 g=A--B;
  if(v==O) v=(abs(vAB.x)>abs(vAB.y))? ((abs(vAB.y)>abs(vAB.z))?Z:Y) : ((abs(vAB.x)>abs(vAB.z))?Z:X);
  transform3 Tp=shift(offset*v);
  pic.add(new void(picture f, transform3 t) {
      picture opic;
      path3 G=Tp*t*g;
      Label L=L.copy();
      draw(opic,L,G,p,arrow);
      triple Ap=t*A, Bp=t*B;
      draw(opic,(Ap--Tp*Ap)^^(Bp--Tp*Bp), joinpen);
      add(f,opic);
    }, true);
}