clc; clear variables; close all;

% imports results4 variable which was created in Data_analysis.m
load('final_results.mat','results4')

% clc
colormap(jet(100))
circulocentralx = -9.5:0.1:9.5;
circulocentraly = sqrt (90.25-circulocentralx.^2);
circuloareax = -9.15:0.05:9.15;
circuloareay = sqrt (83.7225-circuloareax.^2);

results4.Jgadas1=[1:5:1125 2600:5:3150];
Jgadas1=[1:5:1125 2600:5:3150];

xx=0:(1.1483/3):114.83;
yy=0:(1.144/3):74.37;
[X, Y]=meshgrid(xx,yy);
In1BAR1(1:196,1:301,1:length(1:300))=0;
In3BAR1(1:196,1:301,1:length(1:300))=0;
In4BAR1(1:196,1:301,1:length(1:300))=0;

%We follow the same procedure as the one we used when we created the
%heatmap. The only difference is in this case we used the matrix of three 
%dimmension. The new dimmension of our heatmaps will be equal to the time
%we are gonna record a video for, working each point of the matrix as a 
%instant of the video.
for i=2:length(Jgadas1(1:336))
    In1BAR1(:,:,i)=In1BAR1(:,:,i-1);
    In3BAR1(:,:,i)=In3BAR1(:,:,i-1);
    In4BAR1(:,:,i)=In4BAR1(:,:,i-1);
    c=1;
    d=1;
    e=1;
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
                                x2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))  results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))  nan];
                                y2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,(((p-1)*2)+1)))  results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2)) nan];
                                d=d+1;
                            end
                            if  mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2<=37.1850
                                x2(1+(5*(d-1)):1+(5*(d-1))+4)= [results4.x_TeamA(i,results4.ballowner(i))         results4.Def(i,2+(2*(p-1))) results4.x_TeamA(i,results4.index(p,i)) nan nan  ];
                                y2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))   0 results4.y_TeamA(i,results4.index(p,i))   nan nan];
                                d=d+1;
                            end
                            if  mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2>37.1850
                                x2(1+(5*(d-1)):1+(5*(d-1))+4)= [results4.x_TeamA(i,results4.ballowner(i))         results4.Def(i,2+(2*(p-1))) results4.x_TeamA(i,results4.index(p,i)) nan nan  ];
                                y2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i))   74.37 results4.y_TeamA(i,results4.index(p,i))   nan nan];
                                d=d+1;
                            end
                            if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2>37.1850
                                x2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))    results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1))) nan nan];
                                y2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamA(i,results4.index(p,i))  74.37 nan nan];
                                d=d+1;
                            end
                            if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2<=37.1850
                                x2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.x_TeamA(i,results4.ballowner(i))    results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1))) nan nan];
                                y2(1+(5*(d-1)):1+(5*(d-1))+4)=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamA(i,results4.index(p,i))  0 nan nan];
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
                    In1BAR1(:,:,i)=In1BAR1(:,:,i-1)+inpolygon(X,Y,x,y);
                    In3BAR1(:,:,i)=In3BAR1(:,:,i-1)+inpolygon(X,Y,x2,y2);
                    In4BAR1(:,:,i)=In4BAR1(:,:,i-1)+inpolygon(X,Y,x3,y3);
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
                                yf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.y_TeamA(i,results4.ballowner(i)) 0                          results4.y_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                c=c+1;
                            end
                            if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0
                                xf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.x_TeamA(i,results4.ballowner(i))  results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1)) results4.x_TeamA(i,results4.indexf(q,i)) results4.FDef(i,2+(2*(q-1)))  nan];
                                yf(1+(5*(c-1)):1+4+(5*(c-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.y_TeamA(i,results4.indexf(q,i))  74.37                       nan];
                                c=c+1;
                                
                            end
                        end
                        if results4.PRF(i,results4.indexf(q,i))==3
                            if mod(results4.FDef(i,1+(2*(q-1))),1)==0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && abs(results4.FDef(i,1+(2*(q-1)),1))<12 && abs(results4.FDef(i,2+(2*(q-1))))<12
                                xf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                yf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))   results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2)) nan];
                                d=d+1;
                            end
                            
                            if  mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+(results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i))))/2>37.1850
                                xf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,2+(2*(q-1))) results4.x_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  nan];
                                yf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) 74.37                       results4.y_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1)) nan];
                                d=d+1;
                            end
                            if  mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+(results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i))))/2<=37.1850
                                xf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,2+(2*(q-1))) results4.x_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))  nan];
                                yf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) 0            results4.y_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1)) nan];
                                d=d+1;
                            end
                            if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+(results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i))))/2<37.1850
                                
                                xf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i))  results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2)) results4.x_TeamA(i,results4.indexf(q,i)) results4.FDef(i,1+(2*(q-1)))  nan];
                                yf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))  results4.y_TeamA(i,results4.indexf(q,i))  0                            nan];
                                d=d+1;
                                
                            end
                            if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+(results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i))))/2>37.1850
                                xf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.x_TeamA(i,results4.ballowner(i))  results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2)) results4.x_TeamA(i,results4.indexf(q,i)) results4.FDef(i,1+(2*(q-1)))  nan];
                                yf2(1+(5*(d-1)):1+4+(5*(d-1)))=[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))  results4.y_TeamA(i,results4.indexf(q,i)) 74.37                      nan];
                                d=d+1;
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
                    In1BAR1(:,:,i)=In1BAR1(:,:,i)+inpolygon(X,Y,xf,yf);
                    In3BAR1(:,:,i)=In3BAR1(:,:,i-1)+inpolygon(X,Y,xf2,yf2);
                    In4BAR1(:,:,i)=In4BAR1(:,:,i-1)+inpolygon(X,Y,xf3,yf3);
                end
                
            end
            
            
        end
        
    end
end
In1BAR1= In1BAR1/5;
In3BAR1=In3BAR1/5;
In4BAR1=In4BAR1/5;
circulocentralx = -9.5:0.1:9.5;
circulocentraly = sqrt (90.25-circulocentralx.^2);
circuloareax = -9.15:0.05:9.15;
circuloareay = sqrt (83.7225-circuloareax.^2);


subplot(2,2,2)


colormap(jet(100))
cb=1;
cos=1;

% Using the same logic as the one used to create the heatmaps we plot these poligons over the position of players. Potentiall the three heatmaps
% as well as the three type of passes could be shown at the same time. But we choose to plot one pass at a time. To do so, we comment and uncomment
% the parts of the code corresponding to each type of pass.
for i=1:336
    subplot(2,1,1)
    fill([-20 -20 120 120],[-10 80 80 -10],'g')
    hold on
    % Plot the two teams positions as well as their velocities.
    scatter(results4.x_TeamA(i,:), results4.y_TeamA(i,:),'r')
    scatter(results4.x_TeamB(i,:), results4.y_TeamB(i,:),'b')
    for l=1:11
        plot([results4.x_TeamB(i,l) results4.x_TeamB(i,l)+results4.vx_TeamB(i,l)],[results4.y_TeamB(i,l) results4.y_TeamB(i,l)+results4.vy_TeamB(i,l)],'b')
    end
    for l=1:11
        plot([results4.x_TeamA(i,l) results4.x_TeamA(i,l)+results4.vx_TeamA(i,l)],[results4.y_TeamA(i,l) results4.y_TeamA(i,l)+results4.vy_TeamA(i,l)],'r')
    end
    if results4.ballowner(i)~=0
        if results4.teamballowner(i)==1
            
            if results4.counter(i)~=0
                for p=1:results4.counter(i)
                    %                 if results4.PR(i,results4.index(p,i))==1
                    % %                 plot([results4.x_TeamA(i,results4.teamballowner(i)) results4.x_TeamA(i,results4.index(p,i))],[results4.y_TeamA(i,results4.teamballowner(i)) results4.y_TeamA(i,results4.index(p,i))],'k')
                    %                 if mod(results4.Def(i,1+(2*(p-1))),1)==0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && abs(results4.Def(i,1+(2*(p-1)),1))<12 && abs(results4.Def(i,2+(2*(p-1))))<12 && results4.Def(i,2+(2*(p-1)))~=0
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'k')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'k')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'k')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'k')
                    %                 end
                    %
                    %                  if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0
                    %                     plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'k')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'k')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1)))],[results4.y_TeamA(i,results4.index(p,i)) 0],'k')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'k')
                    %                  end
                    %                  if mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0
                    %                      plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'k')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'k')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'k')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.index(p,i)) 74.37],'k')
                    %                  end
                    %
                    %                 end
                    if results4.PR(i,results4.index(p,i))==3
                        %                 plot([results4.x_TeamA(i,results4.teamballowner(i)) results4.x_TeamA(i,results4.index(p,i))],[results4.y_TeamA(i,results4.teamballowner(i)) results4.y_TeamA(i,results4.index(p,i))],'k')
                        if mod(results4.Def(i,1+(2*(p-1))),1)==0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && abs(results4.Def(i,1+(2*(p-1)),1))<12 && abs(results4.Def(i,2+(2*(p-1))))<12 && results4.Def(i,2+(2*(p-1)))~=0
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'b')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'b')
                        end
                        %
                        if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2<=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'b')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1)))],[results4.y_TeamA(i,results4.index(p,i)) 0],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'b')
                        end
                        if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2>=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'b')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1)))],[results4.y_TeamA(i,results4.index(p,i)) 74.37],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'b')
                        end
                        if mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0&& (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2<=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'b')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.index(p,i)) 0],'b')
                        end
                        if mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0&& (results4.y_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.index(p,i)))/2>=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'b')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'b')
                            plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.index(p,i)) 74.37],'b')
                        end
                    end
                    %                 if results4.PR(i,results4.index(p,i))==4
                    % %                 plot([results4.x_TeamA(i,results4.teamballowner(i)) results4.x_TeamA(i,results4.index(p,i))],[results4.y_TeamA(i,results4.teamballowner(i)) results4.y_TeamA(i,results4.index(p,i))],'k')
                    %                 if mod(results4.Def(i,1+(2*(p-1))),1)==0 && mod(results4.Def(i,2+(2*(p-1))),1)==0 && abs(results4.Def(i,1+(2*(p-1)),1))<12 && abs(results4.Def(i,2+(2*(p-1))))<12 && results4.Def(i,2+(2*(p-1)))~=0
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'r')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'r')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'r')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'r')
                    %                 end
                    %
                    %                  if mod(results4.Def(i,1+(2*(p-1))),1)~=0 && mod(results4.Def(i,2+(2*(p-1))),1)==0
                    %                     plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'r')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'r')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,1+(2*(p-1)))],[results4.y_TeamA(i,results4.index(p,i)) 74.37],'r')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+2))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+2))],'r')
                    %                  end
                    %                  if mod(results4.Def(i,2+(2*(p-1))),1)~=0 && mod(results4.Def(i,1+(2*(p-1))),1)==0
                    %                      plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'r')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'r')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.x_TeamB(i, results4.Def(i,((p-1)*2)+1))],[results4.y_TeamA(i,results4.index(p,i)) results4.y_TeamB(i, results4.Def(i,((p-1)*2)+1))],'r')
                    %                       plot([results4.x_TeamA(i,results4.index(p,i)) results4.Def(i,((p-1)*2)+2)],[results4.y_TeamA(i,results4.index(p,i)) 0],'r')
                    %                  end
                    %
                    %             end
                end
            end
            
            if results4.counterf(i)~=0
                for q=1:results4.counterf(i)
                    %                  if results4.PRF(i,results4.indexf(q,i))==1
                    %                % plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i))], 'k')
                    %                  if mod(results4.FDef(i,1+(2*(q-1))),1)==0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && abs(results4.FDef(i,1+(2*(q-1)),1))<12 && abs(results4.FDef(i,2+(2*(q-1))))<12
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'k--')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'k--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'k--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'k--')
                    %                  end
                    %
                    %                  if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0
                    %                     plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'k--')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'k--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,1+(2*(q-1)))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 0],'k--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'k--')
                    %                  end
                    %                  if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0
                    %                      plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'k--')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'k--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'k--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 74.37],'k--')
                    %                  end
                    %                  end
                    if results4.PRF(i,results4.indexf(q,i))==3
                        % plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i))], 'k')
                        if mod(results4.FDef(i,1+(2*(q-1))),1)==0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && abs(results4.FDef(i,1+(2*(q-1)),1))<12 && abs(results4.FDef(i,2+(2*(q-1))))<12
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'b--')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'b--')
                        end
                        if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.vy_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i)))/2<=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'b--')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,1+(2*(q-1)))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 0],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'b--')
                        end
                        if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.vy_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i)))/2>=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'b--')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,1+(2*(q-1)))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 74.37],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'b--')
                        end
                        if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.vy_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i)))/2<=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'b--')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 0],'b--')
                        end
                        if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0 && (results4.y_TeamA(i,results4.ballowner(i))+results4.vy_TeamA(i,results4.ballowner(i))+results4.y_TeamA(i,results4.indexf(q,i))+results4.vy_TeamA(i,results4.indexf(q,i)))/2>=37.1850
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'b--')
                            plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'b--')
                            plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 74.37],'b--')
                        end
                    end
                    %                  if results4.PRF(i,results4.indexf(q,i))==4
                    %                % plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i))], 'k')
                    %                  if mod(results4.FDef(i,1+(2*(q-1))),1)==0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0 && abs(results4.FDef(i,1+(2*(q-1)),1))<12 && abs(results4.FDef(i,2+(2*(q-1))))<12
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'r--')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'r--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'r--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'r--')
                    %                  end
                    %
                    %                  if mod(results4.FDef(i,1+(2*(q-1))),1)~=0 && mod(results4.FDef(i,2+(2*(q-1))),1)==0
                    %                     plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+1)],[results4.y_TeamA(i,results4.ballowner(i)) 74.37],'r--')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'r--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,1+(2*(q-1)))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 74.37],'r--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+2))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+2))],'r--')
                    %                  end
                    %                  if mod(results4.FDef(i,2+(2*(q-1))),1)~=0 && mod(results4.FDef(i,1+(2*(q-1))),1)==0
                    %                      plot([results4.x_TeamA(i,results4.ballowner(i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.ballowner(i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'r--')
                    %                       plot([results4.x_TeamA(i,results4.ballowner(i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.ballowner(i)) 0],'r--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.x_TeamB(i, results4.FDef(i,((q-1)*2)+1))],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) results4.y_TeamB(i, results4.FDef(i,((q-1)*2)+1))],'r--')
                    %                       plot([results4.x_TeamA(i,results4.indexf(q,i))+results4.vx_TeamA(i,results4.indexf(q,i)) results4.FDef(i,((q-1)*2)+2)],[results4.y_TeamA(i,results4.indexf(q,i))-results4.vy_TeamA(i,results4.indexf(q,i)) 0],'r--')
                    %                  end
                    %                  end
                end
            end
        end
    end
   
    scatter(results4.xball(i),results4.yball(i),20,'k','fill')
    plot([0 0],[0 72.1],'-w')
    plot([107.71 107.71],[0 72.1],'-w')
    plot([0 107.71],[0 0],'-w')
    plot([0 107.71],[72.1 72.1],'-w')
    plot([53.855 53.855],[0 72.1],'-w')
    
    %circulo central
    plot (circulocentralx+53.855, circulocentraly+36.05,'-w', -circulocentralx+53.855,-circulocentraly+36.05,'-w')
    plot(53.855,36.05,'.w')
    %areas
    plot (circuloareax(1:74)+96.71, circuloareay(1:74)+36.05,'-w', -circuloareax(294:367)+96.71,-circuloareay(294:367)+36.05,'-w')
    plot([91.2100 107.7100], [15.8 15.8],'-w')
    plot([91.2100  107.7100], [56.30 56.30],'-w')
    plot([91.2100 91.3300], [15.8 56.30],'-w')
    plot([102.2100 107.7100], [26.450 26.450],'-w')
    plot([102.2100 107.7100], [45.650 45.650],'-w')
    plot([102.2100 102.2100], [26.450 45.650],'-w')
    plot(96.71,36.05,'.w')
    
    plot (-circuloareax(1:74)+11, -circuloareay(1:74)+36.05,'-w', +circuloareax(294:367)+11,+circuloareay(294:367)+36.05,'-w')
    plot([0 16.5], [17.025 17.025],'-w')
    plot([0 16.5], [57.3450 57.3450],'-w')
    plot([16.5 16.5],[15.8 56.30],'-w')
    plot([0 5.5], [26.450 26.450],'-w')
    plot([0 5.5], [45.650 45.650],'-w')
    plot([5.5 5.5], [26.450 45.650],'-w')
    plot(11,36.05,'.w')
    axis([-3 110.0 -3 74.00])
    hold off
    
    
    %     subplot(2,1,2)
    %
    %     imagesc([0 100],[0 65],In1BAR1(:,:,i),[0 10])
    %                    hold on
    %
    %     text(45,73,'Penetrative passes')
    %
    %     plot([0 0],[0 65],'-w')
    %     plot([101 101],[0 65],'-w')
    %     plot([0 101],[0 0],'-w')
    %     plot([0 101],[65 65],'-w')
    %     plot([50.5 50.5],[0 65],'-w')
    %     plot(50.5, 32.5,'.w')
    %      plot (circulocentralx+50.5, circulocentraly+32.5,'-w', -circulocentralx+50.5,-circulocentraly+32.50,'-w')
    %
    %        plot (circuloareax(1:74)+90, circuloareay(1:74)+32.5,'-w', -circuloareax(294:367)+90,-circuloareay(294:367)+32.5,'-w')
    %       plot([84.5000 101], [12.3425 12.3425],'-w')
    %     plot([84.5000 101], [52.6575 52.6575],'-w')
    %     plot([84.5000 84.50], [12.3425 52.6575],'-w')
    %     plot([ 95.5000 101], [23.3400 23.3400],'-w')
    %     plot([ 95.5000 101], [41.6600 41.6600],'-w')
    %     plot([ 95.5000 95.500], [23.3400 41.6600],'-w')
    %     plot(90,32.5,'.w')
    %
    %     plot (-circuloareax(1:74)+11, -circuloareay(1:74)+32.50,'-w', +circuloareax(294:367)+11,+circuloareay(294:367)+32.50,'-w')
    %     plot([0 16.5], [12.3425 12.3425],'-w')
    %     plot([0 16.5], [52.6575 52.6575],'-w')
    %     plot([16.5 16.5],[12.3425 52.6575],'-w')
    %     plot([0 5.5], [23.3400 23.3400],'-w')
    %     plot([0 5.5], [41.6600 41.6600],'-w')
    %     plot([5.5 5.5], [23.3400 41.6600],'-w')
    %     plot(11,32.50,'.w')
    %     axis([0 101 0 65])
    %     set(gca,'YDir','normal')
    %     hold off
    subplot(2,1,2)
    imagesc([0 100],[0 65],In3BAR1(:,:,i),[0 10])
    hold on
    text(45,73,'Support passes')
    
    plot([0 0],[0 65],'-w')
    plot([101 101],[0 65],'-w')
    plot([0 101],[0 0],'-w')
    plot([0 101],[65 65],'-w')
    plot([50.5 50.5],[0 65],'-w')
    plot(50.5, 32.5,'.w')
    plot (circulocentralx+50.5, circulocentraly+32.5,'-w', -circulocentralx+50.5,-circulocentraly+32.50,'-w')
    
    plot (circuloareax(1:74)+90, circuloareay(1:74)+32.5,'-w', -circuloareax(294:367)+90,-circuloareay(294:367)+32.5,'-w')
    plot([84.5000 101], [12.3425 12.3425],'-w')
    plot([84.5000 101], [52.6575 52.6575],'-w')
    plot([84.5000 84.50], [12.3425 52.6575],'-w')
    plot([ 95.5000 101], [23.3400 23.3400],'-w')
    plot([ 95.5000 101], [41.6600 41.6600],'-w')
    plot([ 95.5000 95.500], [23.3400 41.6600],'-w')
    plot(90,32.5,'.w')
    
    plot (-circuloareax(1:74)+11, -circuloareay(1:74)+32.50,'-w', +circuloareax(294:367)+11,+circuloareay(294:367)+32.50,'-w')
    plot([0 16.5], [12.3425 12.3425],'-w')
    plot([0 16.5], [52.6575 52.6575],'-w')
    plot([16.5 16.5],[12.3425 52.6575],'-w')
    plot([0 5.5], [23.3400 23.3400],'-w')
    plot([0 5.5], [41.6600 41.6600],'-w')
    plot([5.5 5.5], [23.3400 41.6600],'-w')
    plot(11,32.50,'.w')
    set(gca,'YDir','normal')
    hold off
    %         subplot(2,1,2)
    %     imagesc([0 100],[0 65],In4BAR1(:,:,i),[0 10])
    %         hold on
    %         text(45,73,'Retreat passes')
    %
    %           plot([0 0],[0 65],'-w')
    %     plot([101 101],[0 65],'-w')
    %     plot([0 101],[0 0],'-w')
    %     plot([0 101],[65 65],'-w')
    %     plot([50.5 50.5],[0 65],'-w')
    %     plot(50.5, 32.5,'.w')
    %      plot (circulocentralx+50.5, circulocentraly+32.5,'-w', -circulocentralx+50.5,-circulocentraly+32.50,'-w')
    %
    %        plot (circuloareax(1:74)+90, circuloareay(1:74)+32.5,'-w', -circuloareax(294:367)+90,-circuloareay(294:367)+32.5,'-w')
    %       plot([84.5000 101], [12.3425 12.3425],'-w')
    %     plot([84.5000 101], [52.6575 52.6575],'-w')
    %     plot([84.5000 84.50], [12.3425 52.6575],'-w')
    %     plot([ 95.5000 101], [23.3400 23.3400],'-w')
    %     plot([ 95.5000 101], [41.6600 41.6600],'-w')
    %     plot([ 95.5000 95.500], [23.3400 41.6600],'-w')
    %     plot(90,32.5,'.w')
    %
    %     plot (-circuloareax(1:74)+11, -circuloareay(1:74)+32.50,'-w', +circuloareax(294:367)+11,+circuloareay(294:367)+32.50,'-w')
    %     plot([0 16.5], [12.3425 12.3425],'-w')
    %     plot([0 16.5], [52.6575 52.6575],'-w')
    %     plot([16.5 16.5],[12.3425 52.6575],'-w')
    %     plot([0 5.5], [23.3400 23.3400],'-w')
    %     plot([0 5.5], [41.6600 41.6600],'-w')
    %     plot([5.5 5.5], [23.3400 41.6600],'-w')
    %     plot(11,32.50,'.w')
    %     set(gca,'YDir','normal')
    %      hold off
    
    
    hold off
    F1(i) = getframe(gcf);
    drawnow
    
end

% creates video
writerObj = VideoWriter('video_opportunities.avi');

% set the images per second
writerObj.FrameRate = 5;


% open the video writer
open(writerObj);

% write the frames to the video
for i=1:length(F1)
    % convert the image to a frame
    frame = F1(i).cdata ;
    writeVideo(writerObj, frame);
end
clear(F1)
% close the writer object
close(writerObj)
