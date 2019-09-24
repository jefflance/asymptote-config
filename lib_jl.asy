usepackage("amsmath,amssymb");
usepackage("inputenc","utf8");
usepackage("icomma");
usepackage("esvect");

import graph_pi;
import graph3;
import gm_probabilitytree;
import gm_tableaux;
import geometry;

real w=linewidth();

marker croix1(pen sColor)
{
   return marker(scale(2)*rotate(45)*cross(4), sColor);
}

marker croix2(pen sColor)
{
   return marker(scale(2)*cross(4), sColor);
}

void loadaxis(real xmin, real xmax, real ymin, real ymax)
{
//xlimits(xmin,xmax,Crop);
//ylimits(ymin,ymax,Crop);

xaxis(Label("$x$",position=EndPoint, align=.2*SE),
      xmin=xmin,xmax=xmax,
      Ticks(scale(.7)*Label(align=E),
            NoZero,
            //begin=false,
            end=false,
            //beginlabel=false,
            endlabel=false,
            Step=1,step=.25,
            Size=1mm, size=.5mm,
            pTick=black,ptick=gray),
      Arrow);

yaxis(Label("$y$",position=EndPoint, align=.2*NW),
      ymin=ymin,ymax=ymax,
      Ticks(scale(.7)*Label(),
            NoZero,
            //begin=false,
            end=false,
            //beginlabel=false,
            endlabel=false,
            Step=1,step=.25,
            Size=1mm, size=.5mm,
            pTick=black,ptick=gray),
      Arrow);
}
