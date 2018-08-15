//DCstat-1
//02/03/2009


pen[] couleur={mediumred,mediumcyan,mediumgreen,mediummagenta,mediumblue,yellow,
	orange,fuchsia,brown,heavycyan,heavygreen,heavymagenta,deepblue,white,black};

struct axes{pair min; pair max;real graduationx;real numerotationx;real taillex;real graduationy;real numerotationy;real tailley;}

axes calculaxes(real[] xi,real[] ni,pair ptO=(0,0)){
	axes ax;
	ax.min=ptO;
	ax.max=(max(xi)*1.05,max(ni)*1.05);

	//axe des x
	if (ax.max.x-ax.min.x<1){ax.graduationx=0.025;ax.numerotationx=0.1;}
	else 	if (ax.max.x-ax.min.x<10){ax.graduationx=0.25;ax.numerotationx=1;}
		else 	if (ax.max.x-ax.min.x<100){ax.graduationx=2.5;ax.numerotationx=10;}
			else 	if (ax.max.x-ax.min.x<1000){ax.graduationx=25;ax.numerotationx=100;}
				else 	if (ax.max.x-ax.min.x<10000){ax.graduationx=250;ax.numerotationx=1000;}
					else {ax.graduationx=2500;ax.numerotationx=10000;}

	//données axe y
	ax.tailley=0.0125*(ax.max.x-ax.min.x);
	if (ax.max.y-ax.min.y<1){ax.graduationy=0.025;ax.numerotationy=0.1;}
	else 	if (ax.max.y-ax.min.y<10){ax.graduationy=0.25;ax.numerotationy=1;}
		else 	if (ax.max.y-ax.min.y<100){ax.graduationy=2.5;ax.numerotationy=10;}
			else 	if (ax.max.y-ax.min.y<1000){ax.graduationy=25;ax.numerotationy=100;}
				else 	if (ax.max.y-ax.min.y<10000){ax.graduationy=250;ax.numerotationy=1000;}
					else {ax.graduationy=2500;ax.numerotationy=10000;}

	//retour axe des x
	ax.taillex=0.0125*(ax.max.y-ax.min.y);
	return ax;}

void traceaxe(axes lesaxes,bool axedesy=true,bool origine=true,pair pointO=(0,0), string libellex,string libelley=""){
	//axe des abscisses
	draw((lesaxes.min.x,pointO.y)--(lesaxes.max.x,pointO.y),Arrow(1.5mm));

	//tracé des graduations
	for (int n = round(lesaxes.min.x/lesaxes.graduationx) ; n <= (0.98*lesaxes.max.x)/lesaxes.graduationx; ++ n) {
		draw((n*lesaxes.graduationx,pointO.y-0.5*lesaxes.taillex)--(n*lesaxes.graduationx,pointO.y+0.5*lesaxes.taillex));}

	//tracé des numérotations
	for (int n = round(lesaxes.min.x/lesaxes.numerotationx) ; n <= (0.98*lesaxes.max.x)/lesaxes.numerotationx; ++ n) {
		draw((n*lesaxes.numerotationx,pointO.y-lesaxes.taillex)--(n*lesaxes.numerotationx,pointO.y+lesaxes.taillex));
		if(origine){label(scale(0.6)*format(n*lesaxes.numerotationx),(n*lesaxes.numerotationx,pointO.y-lesaxes.taillex),S);}
		else {if(n!=0){label(scale(0.6)*format(n*lesaxes.numerotationx),(n*lesaxes.numerotationx,pointO.y-lesaxes.taillex),S);}}}

	//Nom de l'axe
	label(scale(0.9)*libellex,(lesaxes.max.x,pointO.y-5*lesaxes.taillex),SW);

	//axe des ordonnées
	if (axedesy) {draw((pointO.x,lesaxes.min.y)--(pointO.x,lesaxes.max.y),Arrow(1.5mm));

	//tracé des graduations
	for (int n = round(lesaxes.min.y/lesaxes.graduationy) ; n <= (0.98*lesaxes.max.y)/lesaxes.graduationy; ++ n) {
	 	draw((pointO.x-0.5*lesaxes.tailley,n*lesaxes.graduationy)--(pointO.x+0.5*lesaxes.tailley,n*lesaxes.graduationy));}

	//tracé des numérotations
	for (int n = round(lesaxes.min.y/lesaxes.numerotationy) ; n <= (0.98*lesaxes.max.y)/lesaxes.numerotationy; ++ n) {
	 	draw((pointO.x-lesaxes.tailley,n*lesaxes.numerotationy)--(pointO.x+lesaxes.tailley,n*lesaxes.numerotationy));
		label(scale(0.6)*format(n*lesaxes.numerotationy),(pointO.x-lesaxes.tailley,n*lesaxes.numerotationy),W);}

	//Nom de l'axe
	label(scale(0.9)*rotate(90)*libelley,(pointO.x-(log10(lesaxes.max.y)+3)*1.5*lesaxes.tailley,lesaxes.max.y),SW);}
}

void diagramme_baton(real[] xi,real[] ni,pen p1=0.5bp+blue,pair origine=(0,0),bool affichey=true,string nomdesx,string nomdesy="Effectif"){

real largeur=0.1;
real hauteur=0;
for(int i=0; i < ni.length;++i){hauteur=hauteur+xi[i];
	filldraw(((xi[i]-largeur),origine.y)--((xi[i]-largeur),ni[i])--((xi[i]+largeur),ni[i])--((xi[i]+largeur),origine.y)--cycle,p1);}

traceaxe(calculaxes(xi,ni,origine),origine,nomdesx,nomdesy);
}


void diagramme_barre(string[] modalite,real[] ni,pen p1=0.5bp+blue,pair origine=(0,0),bool affichey=true,string nomdesy="Effectif"){

//tracé des axes
real[] tbxi;
for (int i=0;i<modalite.length;++i){tbxi[i]=i+1;}
axes ax=calculaxes(tbxi,ni,origine);
ax.graduationx=(abs(ax.max.x)+abs(ax.min.x))*2;
ax.numerotationx=(abs(ax.max.x)+abs(ax.min.x))*2;
ax.max=(ax.max.x+0.5,ax.max.y);
traceaxe(ax,true,false,origine,"",nomdesy);

//les rectangles
real largeur=0.2;
for(int i=0; i < ni.length;++i)
	{filldraw(((i+1-largeur),origine.y)--((i+1-largeur),ni[i])--
	((i+1+largeur),ni[i])--((i+1+largeur),origine.y)--cycle,p1);
	label(scale(0.8)*rotate(90)*modalite[i],(i+1,origine.y),S);}
}

void histogramme(real[] tabxi,real[] tabni,bool axedesy=false,bool unitedaire =true,real uniteaire,pair origine=(0,0),string libellecaractere,string  libelleunite="effectif \'egal \`a "+format(uniteaire),pen p1=.8lightgreen,pen p2=1bp+blue){
//calculs
	// Une variable utile pour déterminer la plus petite amplitude :
	real largeurunite=abs(tabxi[1]-tabxi[0]);
	// ... et une autre pour le numéro de classe correspondant :
	int iclasse=0;
	
	// Calcul des hauteurs (et de la plus petite amplitude de classe) :
	real[] tabhi;
	for(int i=0; i < tabni.length; ++i){
		tabhi[i]=tabni[i]/(tabxi[i+1]-tabxi[i]);
		if (largeurunite>abs(tabxi[i+1]-tabxi[i])) {largeurunite=abs(tabxi[i+1]-tabxi[i]);iclasse=i;}}

	// Hauteur du rectangle le plus haut pour placer l'unité au dessus.
	real hauteurmaxi=max(tabhi);

	// Calcul de la hauteur à donner au rectangle unité d'aire
	real hauteurunite=(uniteaire/tabni[iclasse])*tabhi[iclasse];

	//tracé des axes
	axes ax=calculaxes(tabxi,tabhi,origine);
	traceaxe(ax,axedesy,true,origine,libellecaractere,"hauteurs");
	
	// Hauteur du rectangle le plus haut pour placer l'unité au dessus.
	real hauteurmaxi=max(tabhi);

	// Calcul de la hauteur à donner au rectangle unité d'aire
	real hauteurunite=(uniteaire/tabni[iclasse])*tabhi[iclasse];

	// Tracé de l'histogramme
	for (int i=0; i < tabhi.length;++i){
		//tracé d'un rectangle
		filldraw(box((tabxi[i],origine.y),(tabxi[i+1],tabhi[i])),p1);
		draw((tabxi[i],origine.y)--(tabxi[i],tabhi[i])--(tabxi[i+1],tabhi[i])--(tabxi[i+1],origine.y),p2);}

	// Tracé de l'unité d'aire et son étiquette
	if (unitedaire) {filldraw(box((0.05*ax.max.x,1.1*hauteurmaxi),(0.05*ax.max.x+largeurunite,1.1*hauteurmaxi+hauteurunite)),p1,p2);
		label(scale(0.8)*libelleunite,(0.05*ax.max.x+1.2*largeurunite,1.1*hauteurmaxi+0.5*hauteurunite),E);}

	
}

void diagrammecirculaire(string[] tabmod,real[] tabeff,string nomdugraph=""){

real[] tabangle,tabanglecumule,tabanglelabel;
tabanglecumule[0]=0;
int n=tabeff.length;
for(int i=0; i<n; ++i) {
  tabangle[i]=tabeff[i]*360/sum(tabeff);
  tabanglecumule[i+1]=tabanglecumule[i]+tabangle[i];
  tabanglelabel[i]=tabanglecumule[i]+tabangle[i]/2;  
  path secteur=(0,0)--arc((0,0),1,tabanglecumule[i],tabanglecumule[i+1])--cycle;
  filldraw(secteur,couleur[i]);
  label(scale(0.9)*tabmod[i],(1.6,(i+1)/n),E);
  filldraw((1.4,(i+0.9)/n)--(1.4,(i+1.2)/n)--(1.6,(i+1.2)/n)--(1.6,(i+0.9)/n)--cycle,couleur[i]);} 
label(nomdugraph,(0.5,-1.2),S);}


