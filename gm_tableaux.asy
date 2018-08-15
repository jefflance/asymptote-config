// Un début de quelque chose qui pourrait être une extension, un jour,
// pour tracer des tableaux de signes et/ou variations.

// MAIS, il y a un grand MAIS : si je devais me lancer vraiment
// là dedans... tout serait à repenser pour donner la souplesse
// nécessaire à l'ajout de nouvelles possibilités.

import fontsize;

restricted bool cr=true;
restricted bool decr=false;

picture tabvar(string  var="x",
               string  fonct="f",
               string  deriv="f'(x)",
               string[] lx,
               string[] ly,
               bool3  psv=default,
               real[] v={0,1},
               bool   affderivee=false,
               string[] ld={" "},
               bool   m=true,
               real   x1=1.2,
               real   x2=2.5,
               real   y1=1,
               real   y2=2,
               pen    styletrait=1bp+black,
               pen    stylefleche=styletrait) {
  picture pic;
  real fx(real x) {return 3/2*x1+x*x2;}
  real l=x1/20;
  string d=(m==true)?"$":"";
  int n=lx.length-1;
  while (ly.length<lx.length) ly.push(" ");
  if(psv==cr) {v.delete(); v.push(0);}
  if(psv==decr) {v.delete(); v.push(1);}
  if(v.length==1) (v[0]>0)?v.push(0):v.push(1);
  while (v.length<lx.length) v.push(v[v.length-2]);
  label(pic,d+var+d,(x1/2,-y1/2));
  real delta=0;
  if(affderivee==true) {
    label(pic,d+deriv+d,(x1/2,-3/2*y1));
    delta=-y1;
    draw(pic,(0,-2y1)--(2*x1+n*x2,-2y1),styletrait);
    for(int i=0; i<ld.length; ++i) {
      real xd=3/2*x1+i*x2/2;
      if(ld[i]=="O") {
        draw(pic,circle((xd,-3*y1/2),y1/7));
        draw(pic,(xd,-y1)--(xd,-2*y1),styletrait); }
      else if(ld[i]=="0") {
        label(pic,d+ld[i]+d,(xd,-3*y1/2));
        draw(pic,(xd,-y1)--(xd,-2*y1),styletrait); }
      else if(ld[i]=="VI")
        draw(pic,(xd-l,-y1)--(xd-l,-2*y1)^^(xd+l,-y1)--(xd+l,-2*y1),styletrait);
      else label(pic,d+ld[i]+d,(xd,-3*y1/2));
    }
  }  
  label(pic,d+fonct+d,(x1/2,-3/2*y1+delta-y2/2));
  draw(pic,box((0,0),(2*x1+n*x2,-2*y1+delta-y2)),styletrait);
  draw(pic,(0,-y1)--(2*x1+n*x2,-y1)^^(x1,0)--(x1,-2*y1+delta-y2),styletrait);
  real ymin=min(v), ymax=max(v);
  real[] vn;
  object[] im;
  for(real y:v) vn.push(-3/2*y1+delta-y2+(y-ymin)/(ymax-ymin)*y2);
  int decal=0;
  bool[] relier;
  for(int i=0; i<n+1; ++i) {
    label(pic,d+((m==true)?replace(lx[i],"inf","\infty"):lx[i])+d,(fx(i),-y1/2));
    int pos=rfind(ly[i],"VI");
    if (pos>-1) {
      draw(pic,(fx(i)-l,-y1+delta)--(fx(i)-l,-2*y1+delta-y2)^^(fx(i)+l,-y1+delta)--(fx(i)+l,-2*y1+delta-y2),styletrait);
      string[] lim;
      lim=split(ly[i],"VI");
      int zu=1; if(i==0) zu=0;
      if(i!=0) {
        im.push(draw(pic,Label(d+((m==true)?replace(lim[0],"inf","\infty"):lim[0])+d,align=W),box,(fx(i),vn[i+decal]),invisible));
        relier.push(false);
      }
      if(i!=n) {
        im.push(draw(pic,Label(d+((m==true)?replace(lim[1],"inf","\infty"):lim[1])+d,align=E),box,(fx(i),vn[i+decal+zu]),invisible));
        relier.push(true);
      }
      if(i!=0&&i!=n) {
        ++decal;
        vn.push(vn[vn.length-2]);
      }
    }
    else {
      im.push(draw(pic,d+((m==true)?replace(ly[i],"inf","\infty"):ly[i])+d,box,(fx(i),vn[i+decal]),invisible));
      relier.push(true);
    }
  }
  add(pic,new void(picture pic2, transform t) {
     for(int i=0; i<relier.length-1; ++i){ 
          if(relier[i]){
          pair d=(fx(i+1),vn[i+1])-(fx(i),vn[i]);
          draw(pic2,point(im[i],d,t)--point(im[i+1],-d,t),stylefleche,Arrow(SimpleHead,size=8*linewidth(stylefleche)));
          }
       }
  });
  return pic;
}

picture tabsgn(string[][] tab, real ul=1, real kx=1.1, real ky=1.2 ,pen p=1bp+black, bool m=true){
   picture pic;
   string d=(m==true)?"$":"";
   pen stylo=fontsize(ul*10pt);
   int n=tab.length;
   object[] obj=new object[tab.length];
   real larg,haut;
   for(int k=0; k<n; ++k){
       obj[k]=object(Label("$"+tab[k][0]+"$",stylo));
       larg=max(larg,(max(obj[k])-min(obj[k])).x);
       haut=max(haut,(max(obj[k])-min(obj[k])).y);
   }
   string[] lx;
   lx=split(tab[0][1]," ");
   object[] lxo=new object[lx.length];
   real xlarg,xhaut,dxl=1.1;
   for(int i=0; i<lx.length; ++i){
       lxo[i]=object(Label(d+((m==true)?replace(lx[i],"inf","\infty"):lx[i])+d,stylo));
       xlarg=max(xlarg,(max(lxo[i])-min(lxo[i])).x);
   }
   larg*=kx/2; haut*=ky/2; xlarg*=kx*1.5;
   draw(pic,(-larg,haut-2n*haut)--(-larg,haut)--(larg,haut)--(larg,haut-2n*haut),p);
   for(int k=0; k<n; ++k){
       add(pic,shift(0,-2k*haut)*obj[k]);
       draw(pic,(-larg,haut-2(k+1)*haut)--(larg,haut-2(k+1)*haut),p);
       real L=(lxo.length-1/2)*xlarg;
       if(k==0) {
          draw(pic,(larg,haut)--(dxl^2*larg+L,haut)--(dxl^2*larg+L,-haut)--(larg,-haut),p);
          for(int i=0; i<lxo.length; ++i)
            add(pic,shift(dxl*larg+(1/4+i)*xlarg,0)*lxo[i]);
       } else {
         string[] ly;
         real l=xlarg/30;
         ly=split(tab[k][1]," ");
         for(int i=0; i<ly.length; ++i){
            real xla = dxl*larg+(1/4+i/2)*xlarg;
            if(ly[i]=="O") {
                draw(pic,circle((xla,-k*2haut),haut/2),linewidth(1bp));
                draw(pic,(xla,-k*2haut-haut)--(xla,-k*2haut+haut),p); }
            else if(ly[i]=="0") {
                label(pic,shift(xla,-k*2haut)*(d+ly[i]+d),stylo);
                draw(pic,(xla,-k*2haut-haut)--(xla,-k*2haut+haut),p); }
            else if(ly[i]=="|")
                draw(pic,(xla,-k*2haut-haut)--(xla,-k*2haut+haut),p);
            else if(ly[i]=="||")
                draw(pic,(xla-l,-k*2haut-haut)--(xla-l,-k*2haut+haut)
                         ^^(xla+l,-k*2haut-haut)--(xla+l,-k*2haut+haut),linewidth(1bp));
            else label(pic,shift(xla,-k*2haut)*(d+ly[i]+d),stylo);
         }
         draw(pic,(dxl^2*larg+L,haut-k*2haut)--(dxl^2*larg+L,-haut-k*2haut)--(larg,-haut-k*2haut),p);
       }
   }
   return pic;
}
