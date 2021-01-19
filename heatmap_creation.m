clc; clear variables; close all;

% defines details of the field
circulocentralx = -9.5:0.1:9.5;
circulocentraly = sqrt (90.25-circulocentralx.^2);
circuloareax = -9.15:0.05:9.15;
circuloareay = sqrt (83.7225-circuloareax.^2);

xx=0:(1.1483/3):114.83;
yy=0:(1.144/3):74.37;
[X, Y]=meshgrid(xx,yy);

% considered indices of the plays under study
Jgadas1 = [1:5:1125 2600:5:3150];

% initializing heatmaps
heatmap_penetrative_TeamA(1:196,1:301) = 0;
heatmap_support_TeamA(1:196,1:301) = 0;
heatmap_back_TeamA(1:196,1:301) = 0;

% imports results4 variable which was created in Data_analysis.m
load('final_results.mat','results4')

% What this function does is using PR, PRF, index, indexf, counter and
% counterf its builds the polygons. That are then used to build the
% heatmaps. The vertices of this polygons are saved into x, y, x2...etc
% depending on the type of pass and save into different matrix that are
% used in the end if this script to create the heatmaps.To do so the
% function inpolygon is used.
for i=2:length(Jgadas1)
    heatmap_penetrative_TeamA(:,:,i) = heatmap_penetrative_TeamA(:,:,i-1);
    heatmap_support_TeamA(:,:,i) = heatmap_support_TeamA(:,:,i-1);
    heatmap_back_TeamA(:,:,i) = heatmap_back_TeamA(:,:,i-1);
    
    c=1;
    d=1;
    e=1;
    %With this we ensure the polygons lay outside the field in case we do not have enough passes.
    y=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    x=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    yf=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    xf=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    y2=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    x2=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    yf2=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    xf2=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    y3=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    x3=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    yf3=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    xf3=[-10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan -10000 -10000 -10000 -10000 nan];
    if Jgadas1(i)<70704
        if results4.ballowner(i)~=0
            if results4.teamballowner(i)==1
                if results4.counter(i)~=0
                    for p=1:results4.counter(i)
                        if results4.PR(i,results4.index(p,i))==1
                            if mod(results4.Def(i,1+(2*(p-1))),1)==0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && abs(results4.Def(i,1+(2*(p-1)),1))<12 && abs(results4.Def(i,2+(2*(p-1))))<12 && results4.Def(i,2+(2*(p-1)))~=0
                                x(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))  results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))  nan];
                                y(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,(((p-1)*2)+1)))  results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                c=c+1;
                            end
                            if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0
                                x(1+(5*(c-1)):1+(5*(c-1))+4)=[results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,1+(2*(p-1)))   results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                y(1+(5*(c-1)):1+(5*(c-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) 0  results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                c=c+1;
                            end
                            if mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0
                                x(1+(5*(c-1)):1+(5*(c-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))   results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))  results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,2+(2*(p-1))) nan];
                                y(1+(5*(c-1)):1+(5*(c-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))  results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1)) results4.y_TeamA(i,results4.index(p,i))  74.37 nan];
                                c=c+1;
                            end
                        end
                        if results4.PR(i,results4.index(p,i))==3
                            if mod(results4.Def(i,1+(2*(p-1))),1)==0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && abs(results4.Def(i,1+(2*(p-1)),1))<12 && abs(results4.Def(i,2+(2*(p-1))))<12 && results4.Def(i,2+(2*(p-1)))~=0
                                x3(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))  results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))  nan];
                                y3(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,(((p-1)*2)+1)))  results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                d=d+1;
                            end
                            if  mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2<=37.1850
                                x3(1+(5*(d-1)):1+(5*(d-1))+4)= [results4.x_TeamA(i,results4.ballowner(i))         results4.Def(i,2+(2*(p-1))) results4.x_TeamA(i,results4.index(p,i)) nan nan  ];
                                y3(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))   0 results4.y_TeamA(i,results4.index(p,i))   nan nan];
                                d=d+1;
                            end
                            if  mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2>37.1850
                                x3(1+(5*(d-1)):1+(5*(d-1))+4)= [results4.x_TeamA(i,results4.ballowner(i))         results4.Def(i,2+(2*(p-1))) results4.x_TeamA(i,results4.index(p,i)) nan nan  ];
                                y3(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))   74.37 results4.y_TeamA(i,results4.index(p,i))   nan nan];
                                d=d+1;
                            end
                            if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2>37.1850
                                x3(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))    results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1))) nan nan];
                                y3(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamA(i,results4.index(p,i))  74.37 nan nan];
                                d=d+1;
                            end
                            if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2<=37.1850
                                x3(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))    results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1))) nan nan];
                                y3(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamA(i,results4.index(p,i))  0 nan nan];
                                d=d+1;
                            end
                        end
                        if results4.PR(i,results4.index(p,i))==4
                            if mod(results4.Def(i,1+(2*(p-1))),1)==0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && abs(results4.Def(i,1+(2*(p-1)),1))<12 && abs(results4.Def(i,2+(2*(p-1))))<12 && results4.Def(i,2+(2*(p-1)))~=0
                                x3(1+(5*(e-1)):1+4+(5*(e-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))  results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))  nan];
                                y3(1+(5*(e-1)):1+4+(5*(e-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,(((p-1)*2)+1)))  results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                e=e+1;
                            end
                            if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0
                                x3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,1+(2*(p-1)))   results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                y3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) 74.37  results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                e=e+1;
                            end
                            if mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0
                                x3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))   results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))  results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,2+(2*(p-1))) nan];
                                y3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))  results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1)) results4.y_TeamA(i,results4.index(p,i))  0 nan];
                                e=e+1;
                            end
                        end
                    end
                    heatmap_penetrative_TeamA(:,:,i) = ...
                        heatmap_penetrative_TeamA(:,:,i-1)+inpolygon(X,Y,x,y);
                    
                    heatmap_support_TeamA(:,:,i) = ...
                        heatmap_support_TeamA(:,:,i-1)+inpolygon(X,Y,x2,y2);
                    
                    heatmap_back_TeamA(:,:,i) = ...
                        heatmap_back_TeamA(:,:,i-1)+inpolygon(X,Y,x3,y3);
                end
                if results4.counterf(i)~=0
                    c=1;
                    d=1;
                    e=1;
                    for q=1:results4.counterf(i)
                        if results4.PRF(i,results4.indexf(q,i))==1
                            
                            if mod(results4.FDef(i,1+(2*(q-1))),1)==0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && abs(results4.FDef(i,1+(2*(q-1)),1))<12 && abs(results4.FDef(i,2+(2*(q-1))))<12
                                xf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                yf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))   results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                c=c+1;
                            end
                            
                            if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0
                                xf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,1+(2*(q-1))) results4.x_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))  nan];
                                yf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.y_TeamA(i,results4.ballowner(i)) 74.37                           results4.y_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                c=c+1;
                            end
                            if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0
                                xf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.x_TeamA(i,results4.ballowner(i))  results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1)) results4.x_TeamA(i,results4.indexf(q,i)) results4.FDef(i,2+(2*(q-1)))  nan];
                                yf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.y_TeamA(i,results4.indexf(q,i))  0                        nan];
                                c=c+1;
                                
                            end
                        end
                        if results4.PRF(i,results4.indexf(q,i))==3
                            if mod(results4.FDef(i,1+(2*(q-1))),1)==0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && abs(results4.FDef(i,1+(2*(q-1)),1))<12 && abs(results4.FDef(i,2+(2*(q-1))))<12 && results4.FDef(i,2+(2*(q-1)))~=0
                                xf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))  nan];
                                yf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,(((q-1)*2)+1)))  results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                d=d+1;
                            end
                            if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0
                                xf2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,1+(2*(q-1)))   results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                yf2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) 74.37  results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                d=d+1;
                            end
                            if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0
                                xf2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))   results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,2+(2*(q-1))) nan];
                                yf2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))  results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1)) results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 0 nan];
                                e=e+1;
                            end
                        end
                        if results4.PRF(i,results4.indexf(q,i))==4
                            if mod(results4.FDef(i,1+(2*(q-1))),1)==0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && abs(results4.FDef(i,1+(2*(q-1)),1))<12 && abs(results4.FDef(i,2+(2*(q-1))))<12 && results4.FDef(i,2+(2*(q-1)))~=0
                                xf3(1+(5*(e-1)):1+4+(5*(e-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))  nan];
                                yf3(1+(5*(e-1)):1+4+(5*(e-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,(((q-1)*2)+1)))  results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                e=e+1;
                            end
                            if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0
                                xf3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,1+(2*(q-1)))   results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                yf3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) 74.37  results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                e=e+1;
                            end
                            if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0
                                xf3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))   results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.x_TeamA(i,results4.indexf(q,i)) results4.FDef(i,2+(2*(q-1))) nan];
                                yf3(1+(5*(e-1)):1+(5*(e-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))  results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1)) results4.y_TeamA(i,results4.indexf(q,i))  0 nan];
                                e=e+1;
                            end
                        end
                    end
                    heatmap_penetrative_TeamA(:,:,i) = ...
                        heatmap_penetrative_TeamA(:,:,i)+inpolygon(X,Y,xf,yf);
                    heatmap_support_TeamA(:,:,i) = ...
                        heatmap_support_TeamA(:,:,i-1)+inpolygon(X,Y,xf2,yf2);
                    heatmap_back_TeamA(:,:,i) = ...
                        heatmap_back_TeamA(:,:,i-1)+inpolygon(X,Y,xf3,yf3);
                end
                
            end
            
            
        end
        
    end
end

heatmap_penetrative_TeamA = heatmap_penetrative_TeamA/5;
heatmap_support_TeamA = heatmap_support_TeamA/5;
heatmap_back_TeamA = heatmap_back_TeamA/5;

max(heatmap_penetrative_TeamA);
max(ans)
max(heatmap_support_TeamA);
max(ans)
max(heatmap_back_TeamA);
max(ans)

figure (1)
imagesc([0 100],[0 70],heatmap_penetrative_TeamA(:,:,end),[0 10])
hold on
colormap(jet(100))

plot([0 0],[0 70],'-w')
plot([101 101],[0 70],'-w')
plot([0 101],[0 0],'-w')
plot([0 101],[70 70],'-w')
plot([50.5 50.5],[0 70],'-w')
plot(50.5, 32.5,'.w')
plot (circulocentralx+50.5, circulocentraly+32.5,'-w', -circulocentralx+50.5,-circulocentraly+32.50,'-w')

plot (circuloareax(1:74)+90, circuloareay(1:74)+32.5,'-w', -circuloareax(294:367)+90,-circuloareay(294:367)+32.5,'-w')
plot([84.5000 101], [12.3425 12.3425],'-w')
plot([84.5000 101], [52.7075 52.7075],'-w')
plot([84.5000 84.50], [12.3425 52.7075],'-w')
plot([ 95.5000 101], [23.3400 23.3400],'-w')
plot([ 95.5000 101], [41.6600 41.6600],'-w')
plot([ 95.5000 95.500], [23.3400 41.6600],'-w')
plot(90,32.5,'.w')

plot (-circuloareax(1:74)+11, -circuloareay(1:74)+32.50,'-w', +circuloareax(294:367)+11,+circuloareay(294:367)+32.50,'-w')
plot([0 16.5], [12.3425 12.3425],'-w')
plot([0 16.5], [52.7075 52.7075],'-w')
plot([16.5 16.5],[12.3425 52.7075],'-w')
plot([0 5.5], [23.3400 23.3400],'-w')
plot([0 5.5], [41.6600 41.6600],'-w')
plot([5.5 5.5], [23.3400 41.6600],'-w')
plot(11,32.50,'.w')
colorbar
set(gca,'YDir','normal')

text(35,75,'Penetrative passes')
hold off
figure(2)
imagesc([0 100],[0 70],heatmap_support_TeamA(:,:,end),[0 10])
hold on
colormap(jet(100))

plot([0 0],[0 70],'-w')
plot([101 101],[0 70],'-w')
plot([0 101],[0 0],'-w')
plot([0 101],[70 70],'-w')
plot([50.5 50.5],[0 70],'-w')
plot(50.5, 32.5,'.w')
plot (circulocentralx+50.5, circulocentraly+32.5,'-w', -circulocentralx+50.5,-circulocentraly+32.50,'-w')

plot (circuloareax(1:74)+90, circuloareay(1:74)+32.5,'-w', -circuloareax(294:367)+90,-circuloareay(294:367)+32.5,'-w')
plot([84.5000 101], [12.3425 12.3425],'-w')
plot([84.5000 101], [52.7075 52.7075],'-w')
plot([84.5000 84.50], [12.3425 52.7075],'-w')
plot([ 95.5000 101], [23.3400 23.3400],'-w')
plot([ 95.5000 101], [41.6600 41.6600],'-w')
plot([ 95.5000 95.500], [23.3400 41.6600],'-w')
plot(90,32.5,'.w')

plot (-circuloareax(1:74)+11, -circuloareay(1:74)+32.50,'-w', +circuloareax(294:367)+11,+circuloareay(294:367)+32.50,'-w')
plot([0 16.5], [12.3425 12.3425],'-w')
plot([0 16.5], [52.7075 52.7075],'-w')
plot([16.5 16.5],[12.3425 52.7075],'-w')
plot([0 5.5], [23.3400 23.3400],'-w')
plot([0 5.5], [41.6600 41.6600],'-w')
plot([5.5 5.5], [23.3400 41.6600],'-w')
plot(11,32.50,'.w')
set(gca,'YDir','normal')
colorbar
text(35,75,'Support passes')
hold off
figure(3)
imagesc([0 100],[0 70],heatmap_back_TeamA(:,:,end),[0 10])
hold on
colormap(jet(100))

plot([0 0],[0 70],'-w')
plot([101 101],[0 70],'-w')
plot([0 101],[0 0],'-w')
plot([0 101],[70 70],'-w')
plot([50.5 50.5],[0 70],'-w')
plot(50.5, 32.5,'.w')
plot (circulocentralx+50.5, circulocentraly+32.5,'-w', -circulocentralx+50.5,-circulocentraly+32.50,'-w')

plot (circuloareax(1:74)+90, circuloareay(1:74)+32.5,'-w', -circuloareax(294:367)+90,-circuloareay(294:367)+32.5,'-w')
plot([84.5000 101], [12.3425 12.3425],'-w')
plot([84.5000 101], [52.7075 52.7075],'-w')
plot([84.5000 84.50], [12.3425 52.7075],'-w')
plot([ 95.5000 101], [23.3400 23.3400],'-w')
plot([ 95.5000 101], [41.6600 41.6600],'-w')
plot([ 95.5000 95.500], [23.3400 41.6600],'-w')
plot(90,32.5,'.w')

plot(-circuloareax(1:74)+11, -circuloareay(1:74)+32.50,'-w', +circuloareax(294:367)+11,+circuloareay(294:367)+32.50,'-w')
plot([0 16.5], [12.3425 12.3425],'-w')
plot([0 16.5], [52.7075 52.7075],'-w')
plot([16.5 16.5],[12.3425 52.7075],'-w')
plot([0 5.5], [23.3400 23.3400],'-w')
plot([0 5.5], [41.6600 41.6600],'-w')
plot([5.5 5.5], [23.3400 41.6600],'-w')
plot(11,32.50,'.w')
set(gca,'YDir','normal')
colorbar
text(35,75,'Retreat passes')
hold off

results4.Jgadas1 = Jgadas1;
save1.ppasses = heatmap_penetrative_TeamA(:,:);
save1.spasses = heatmap_support_TeamA(:,:);
save1.heatmap_back_TeamA = heatmap_back_TeamA(:,:);
save1.results4=results4;

save('heatmap_results.mat','save1')
