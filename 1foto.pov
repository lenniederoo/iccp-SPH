#include "colors.inc"

sky_sphere {pigment {rgb <0.9,0.9,0.9>}}
light_source {<45,30,40> White*2.5}
camera {
perspective
location <80,40,50>//<45,30,40>
look_at <0,0,0>
angle 30
}
#fopen file "./Data/00001.dat" read
#read (file,Var1)
#declare GROSOR = 0.1;
#declare REGION= Var1;
union{
box {<-REGION,-REGION,-REGION>,<REGION,REGION,REGION>
pigment
{rgbf<0.9,0.9,1,1.01>}
finish {reflection {0.03}}
hollow
}


cylinder{<REGION,-REGION,-REGION>, <REGION,REGION,-REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<REGION,REGION,-REGION>, <-REGION,REGION,-REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<-REGION,-REGION,-REGION>, <REGION,-REGION,-REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<-REGION,-REGION,-REGION>, <-REGION,REGION,-REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<REGION,-REGION,-REGION>, <REGION,-REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<REGION,REGION,-REGION>, <REGION,REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<REGION,-REGION,REGION>, <REGION,REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<REGION,REGION,REGION>, <-REGION,REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<-REGION,-REGION,-REGION>, <-REGION,-REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<-REGION,-REGION,REGION>, <-REGION,REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<-REGION,-REGION,REGION>, <REGION,-REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}}
cylinder{<-REGION,REGION,-REGION>, <-REGION,REGION,REGION>,GROSOR pigment {rgb<1,1,0.1>}} 
}
#while (defined(file))
#read (file,Var1)
#read (file,Var2)
#read (file,Var3)


sphere {<Var1,Var3,Var2>,0.5
pigment {rgb</*Var8*/0,/*Var9*/0,/*Var10*/1>}
finish {phong .2 reflection {.03}}
}


//cylinder{<Var1,Var2,Var3>, <Var4,Var5,Var6>,0.15 pigment {rgbf<0.8,0,0,0.4>}}
#end
#fclose file
