function [PR, PRF, Def, FDef, outfieldplayers, Foutfieldplayers] ...
    = passing_linesD(xteam1, yteam1, xteam2, yteam2,rx1,ry1,rx2,ry2,newseriesteam2,...
    teamballowner, ballowner, ejected ,half, distanceBT,distanceFBT,distanceOT)
%First the varaibles tha are going to be use in the algorithm are created. 
outfieldplayers(1:11)=0;
Foutfieldplayers(1:11)=0;
distance(1:11)=0;
distanceF(1:11)=0;
distancefff(1:11)=0;
PR(1:11)=0;
PRF(1:11)=0;
ins(1:11)=0;
insf(1:11)=0;
h=1;
l=1;
Def(1:20)=0;
FDef(1:20)=0;
index=1:11;
indexf=1:11;
% bolean=ejected(1);
% teamejected=ejected(2);
% playerejected=ejected(3);
aa(200,2)=0;
seg(1:200,1:4)=0;
%% Total velocity of defensive palyers
%The total velocity of the players in the defensive unit is created. 
vtteam2=sqrt(rx2.^2+ry2.^2);

%% For each attacking player how many opposing players are outfield.
%Using the distane to the goal we calculate the number of players outfield
%by each attacker. 
outfield(1:11)=0;
Foutfield(1:11)=0;
for i=1:11
    a=1;
    b=1;
    for j=1:11
        if abs(distanceBT(i))<abs(distanceOT(j))
            outfield(i)=a;
            a=a+1;
        end
        if abs(distanceFBT(i))<abs(distanceOT(j))
            Foutfield(i)=b;
            b=b+1;
        end
    end
end

%% Angles and areas
%Now using the total velocity of the players we generate areas with 200
%points. To do so we used also the velocity adaptations (newseries) created
%before. The end effect are lines that go to the end of the field and that
%pass through points that are used to scale the time the player will take
%to arrive to any of the points of that lines. Such that these points
%represent were the player can be a second later. 
seriesangle=[360 280 240 160 100 90 80 60 40];
seriesvelocity=[0 1 2 3 4 5 6 7 8];
Anglesvalues=interp1(seriesvelocity,seriesangle,0:8/100:8)';
Anglesvalues=deg2rad(Anglesvalues);
angleteam2=atan2(rx2,ry2);
nearervalueteam2(1:11)=0;
sumangleteam2(1:11)=0;
resangleteam2(1:11)=0;

 [~, nearervalueteam2(:)]=min(abs(newseriesteam2-vtteam2));

for j=1:11
    sumangleteam2(j)= angleteam2(j)+(Anglesvalues(nearervalueteam2(j))/2);
    resangleteam2(j)= angleteam2(j)-(Anglesvalues(nearervalueteam2(j))/2);
end
    

finalangleteam2(1:11,1:200)=0;

for i=1:11
finalangleteam2(i,:)=linspace(sumangleteam2(i),resangleteam2(i),200);
end
xpoints(1:200,1:11)=0;
ypoints(1:200,1:11)=0;
for i=1:11
    if vtteam2(i)>1.5
       xpoints(1:200,i)=xteam2(i)+(sin(finalangleteam2(i,:))*vtteam2(i))';
       ypoints(1:200,i)=yteam2(i)+(cos(finalangleteam2(i,:))*vtteam2(i))';
    end
    if vtteam2(i)<=1.5
       xpoints(1:200,i)=xteam2(i)+(sin(finalangleteam2(i,:))*1.5)';
       ypoints(1:200,i)=yteam2(i)+(cos(finalangleteam2(i,:))*1.5)';
    end
end

finalx(1:200,1:11)=0;
finaly(1:200,1:11)=0;
for j=1:11
    for i=1:200
        if xpoints(i,j)-xteam2(j)==0 && ypoints(i,j)-yteam2(j)>0
          finalx(i,j)=xpoints(i,j);
          finaly(i,j)=74.83;
        end
        if xpoints(i,j)-xteam2(j)==0 && ypoints(i,j)-yteam2(j)<0
          finalx(i,j)=xpoints(i,j);
          finaly(i,j)=0;
        end
        if xpoints(i,j)-xteam2(j)>0 
          a=(114.83-xteam2(j));
          b=(xpoints(i,j)-xteam2(j))/(ypoints(i,j)-yteam2(j));
          finaly(i,j)=a/b+ypoints(i,j); 
          finalx(i,j)=114.83;
        end
        if xpoints(i,j)-xteam2(j)<0
          a=(0-xteam2(j));
          b=(xpoints(i,j)-xteam2(j))/(ypoints(i,j)-yteam2(j));
          finaly(i,j)=a/b+ypoints(i,j);  
          finalx(i,j)=0;
        end 
    end
end

%% Algorithm
%Now using all the previously created elements we run the algorithm. I
%commented the frist half but the other one works exactly the same. 
for i=1:11
    if half==1
            if teamballowner==1
                if i==ballowner
                    %if the player is the ballowner a 2 is marked in PR(i)
                    %and PRF(i).
                    PR(i)=2;
                    PRF(i)=2;
                    outfieldplayers(i)=outfield(ballowner);
                end
                
                if i~=ballowner && outfield(ballowner)<outfield(i) 
                    %If the player i is outfielding more players than the 
                    % ballowner a 1 is marked.
                     PR(i)=1;
                     for j=1:11          
                         % The area segments are used for each player to
                         % calculate if the defensive player can arrive to
                         % that passing line before the player can arrive
                         % to it. If the ball velocity wants to be
                         % modified it must be in the end part of
                         % lineSegmentIntersect. 
                            aa(1:200,1)=xteam2(j);
                            aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i) yteam1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distance(j), ins(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     % After each defensive player is calculated we test if
                     % the Sum of TF (a 200 length TF bolean) is higher
                     % than 1. If TF is 0 none of the lines passing
                     % throught the areas allows the player to arrive
                     % faster than the ball to that point. If TF is higher
                     % than 1 (or different to 0) at least one of the lines
                     % allows the defense to arrive before the ball. If
                     % this happens PR(i)=0. 
                      if sum(T_F)~=0 || abs(distance(j))<1 || abs(distancefff(j))<1
                        PR(i)=0;
                     end
                     end 
                     if  PR(i)==1
                       %if the pass couldnt be intercepted the defensive
                       %players that are nearer in each side are
                       %calculated. Or in its defect the nearest point in
                       %the sideline. 
                     index(ins==0)=[];
                     distance(ins==0)=[];
                     ins(ins==0)=[];
                     right=find(distance(:)<0);
                     left=find(distance(:)>0);
                     if isempty(right)
                        distanceright(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                        distanceright(:,2)=0;
                     end
                     if isempty(left)
                         distanceleft(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                         distanceleft(:,2)=0;
                     end
                     if ~isempty(left)
                         distanceleft(:,2)=distance(distance(:)>0);
                         distanceleft(:,1)=index(distance(:)>0);
                     end
                     if ~isempty(right)
                          distanceright(:,1)=index(distance(:)<0);
                          distanceright(:,2)=distance(distance(:)<0);
                     end
                     distanceleft=sortrows(distanceleft,2);
                     distanceright=sortrows(distanceright,2,'descend');
                     Def(h)=distanceright(1,1);
                     Def(h+1)=distanceleft(1,1);
                     h=h+2;
                     outfieldplayers(i)=outfield(i)-outfield(ballowner);
                     distanceright=[];
                     distanceleft=[];
                     index=1:11;
                     ins(1:11)=0;
                     distance(1:11)=0;
                     end

                end
   
                if i~=ballowner && outfield(ballowner)==outfield(i) && (i~=1 || xteam1(ballowner)>57.4150)
                    %All the others work like this. The only difference comes with the number
                    % of outfield players in each case. PR=3 means support
                    % passes while PR=4 means retreat passes. 
                    PR(i)=3;
                    for j=1:11                        
aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                          seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                      out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i) yteam1(i)],xpoints(:,j),ypoints(:,j));
                      T_F=sum(out.intAdjacencyMatrix);
                      [distance(j), ins(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distance(j))<1 || abs(distancefff(j))<1
                        PR(i)=0;
                     end
                    end
                     if  PR(i)==3
                     right=find(distance(:)<0);
                     left=find(distance(:)>0);
                     if isempty(right)
                        distanceright(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                        distanceright(:,2)=0;
                     end
                     if isempty(left)
                         distanceleft(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                         distanceleft(:,2)=0;
                     end
                     if ~isempty(left)
                         distanceleft(:,2)=distance(distance(:)>0);
                         distanceleft(:,1)=index(distance(:)>0);
                     end
                     if ~isempty(right)
                          distanceright(:,1)=index(distance(:)<0);
                          distanceright(:,2)=distance(distance(:)<0);
                     end
                     distanceleft=sortrows(distanceleft,2);
                     distanceright=sortrows(distanceright,2,'descend');
                     Def(h)=distanceright(1,1);
                     Def(h+1)=distanceleft(1,1);
                     h=h+2;
                     outfieldplayers(i)=outfield(i)-outfield(ballowner);
                     distanceright=[];
                     distanceleft=[];
                     index=1:11;
                     ins(1:11)=0;
                     distance(1:11)=0;
                     end

                end
                if i~=ballowner && outfield(ballowner)>outfield(i) && (i~=1 || xteam1(ballowner)>57.4150)
                     PR(i)=4;
                     for j=1:11
  aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i) yteam1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distance(j), ins(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distance(j))<1 || abs(distancefff(j))<1
                        PR(i)=0;
                     end
                     end 
                     if  PR(i)==4
               index(ins==0)=[];
                     distance(ins==0)=[];
                     ins(ins==0)=[];
                     right=find(distance(:)<0);
                     left=find(distance(:)>0);
                     if isempty(right)
                        distanceright(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                        distanceright(:,2)=0;
                     end
                     if isempty(left)
                         distanceleft(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                         distanceleft(:,2)=0;
                     end
                     if ~isempty(left)
                         distanceleft(:,2)=distance(distance(:)>0);
                         distanceleft(:,1)=index(distance(:)>0);
                     end
                     if ~isempty(right)
                          distanceright(:,1)=index(distance(:)<0);
                          distanceright(:,2)=distance(distance(:)<0);
                     end
                     distanceleft=sortrows(distanceleft,2);
                     distanceright=sortrows(distanceright,2,'descend');
                     Def(h)=distanceright(1,1);
                     Def(h+1)=distanceleft(1,1);
                     h=h+2;
                     outfieldplayers(i)=outfield(i)-outfield(ballowner);
                     distanceright=[];
                     distanceleft=[];
                     index=1:11;
                     ins(1:11)=0;
                     distance(1:11)=0;
                     end

                end
                 if i~=ballowner && outfield(ballowner)<Foutfield(i)  && sqrt(rx1(i).^2+ry1(i).^2)>2
                     PRF(i)=1;
                     % This is the same as for PR with the difference that
                     % all the calculations are made for the future (1
                     % second later position of the player). This is only
                     % activated if the player is moving at velocities
                     % higher than 2 m/s.
                     for j=1:11
  aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i)+rx1(i) yteam1(i)+ry1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distanceF(j), insf(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distanceF(j))<1 || abs(distancefff(j))<1
                        PRF(i)=0;
                     end
                     end 
                     if PRF(i)==1
                     indexf(insf==0)=[];
                     distanceF(insf==0)=[];
                     insf(insf==0)=[];
                     rightf=find(distanceF(:)<0);
                     leftf=find(distanceF(:)>0);
                     if isempty(rightf)
                       distancerightF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                       distancerightF(:,2)=0;
                     end
                     if isempty(leftf)
                         distanceleftF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                         distanceleftF(:,2)=0;
                     end
                     if ~isempty(leftf)
                         distanceleftF(:,2)=distanceF(distanceF(:)>0);
                         distanceleftF(:,1)=indexf(distanceF(:)>0);
                     end
                     if ~isempty(rightf)
                          distancerightF(:,1)=indexf(distanceF(:)<0);
                          distancerightF(:,2)=distanceF(distanceF(:)<0);
                     end
                     distanceleftF=sortrows(distanceleftF,2);
                     distancerightF=sortrows(distancerightF,2,'descend');
                     FDef(l)=distancerightF(1,1);
                     FDef(l+1)=distanceleftF(1,1);
                     l=l+2;
                     Foutfieldplayers(i)=Foutfield(i)-outfield(ballowner);
                     distancerightF=[];
                     distanceleftF=[];
                     indexf=1:11;
                     insf(1:11)=0;
                     distanceF(1:11)=0;
                     end

                 end
                  if i~=ballowner && outfield(ballowner)==Foutfield(i)  && sqrt(rx1(i).^2+ry1(i).^2)>2 && (i~=1 || xteam1(ballowner)>57.4150)
                     PRF(i)=3;
                      for j=1:11
  aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i)+rx1(i) yteam1(i)+ry1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distanceF(j), insf(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distanceF(j))<1 || abs(distancefff(j))<1
                        PRF(i)=0;
                     end
                     end 
                     if PRF(i)==3
                     rightf=find(distanceF(:)<0);
                     leftf=find(distanceF(:)>0);
                     if isempty(rightf)
                       distancerightF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                       distancerightF(:,2)=0;
                     end
                     if isempty(leftf)
                         distanceleftF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                         distanceleftF(:,2)=0;
                     end
                     if ~isempty(leftf)
                         distanceleftF(:,2)=distanceF(distanceF(:)>0);
                         distanceleftF(:,1)=indexf(distanceF(:)>0);
                     end
                     if ~isempty(rightf)
                          distancerightF(:,1)=indexf(distanceF(:)<0);
                          distancerightF(:,2)=distanceF(distanceF(:)<0);
                     end
                     distanceleftF=sortrows(distanceleftF,2);
                     distancerightF=sortrows(distancerightF,2,'descend');
                     FDef(l)=distancerightF(1,1);
                     FDef(l+1)=distanceleftF(1,1);
                     l=l+2;
                     Foutfieldplayers(i)=Foutfield(i)-outfield(ballowner);
                     distancerightF=[];
                     distanceleftF=[];
                     indexf=1:11;
                     insf(1:11)=0;
                     distanceF(1:11)=0;
                     end

                  end
                  if i~=ballowner && outfield(ballowner)>Foutfield(i) && sqrt(rx1(i).^2+ry1(i).^2)>2 && (i~=1 || xteam1(ballowner)>57.4150)
                     PRF(i)=4;
                     for j=1:11
  aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i)+rx1(i) yteam1(i)+ry1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distanceF(j), insf(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distanceF(j))<1 || abs(distancefff(j))<1
                        PRF(i)=0;
                     end
                     end 
                     if  PRF(i)==4
                     indexf(insf==0)=[];
                     distanceF(insf==0)=[];
                     insf(insf==0)=[];
                     rightf=find(distanceF(:)<0);
                     leftf=find(distanceF(:)>0);
                     if isempty(rightf)
                       distancerightF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                       distancerightF(:,2)=0;
                     end
                     if isempty(leftf)
                         distanceleftF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                         distanceleftF(:,2)=0;
                     end
                     if ~isempty(leftf)
                         distanceleftF(:,2)=distanceF(distanceF(:)>0);
                         distanceleftF(:,1)=indexf(distanceF(:)>0);
                     end
                     if ~isempty(rightf)
                          distancerightF(:,1)=indexf(distanceF(:)<0);
                          distancerightF(:,2)=distanceF(distanceF(:)<0);
                     end
                     distanceleftF=sortrows(distanceleftF,2);
                     distancerightF=sortrows(distancerightF,2,'descend');
                     FDef(l)=distancerightF(1,1);
                     FDef(l+1)=distanceleftF(1,1);
                     l=l+2;
                     distancerightF=[];
                     distanceleftF=[];
                     indexf=1:11;
                     Foutfieldplayers(i)=Foutfield(i)-outfield(ballowner);
                     insf(1:11)=0;
                     distanceF(1:11)=0;
                     end
                 end
            end   


    end
        if half==2
            if teamballowner==1
                if i==ballowner
                    PR(i)=2;
                    PRF(i)=2;
                    outfieldplayers(i)=outfield(ballowner);
                end
                if i~=ballowner && outfield(ballowner)<outfield(i) 
                     PR(i)=1;
                     for j=1:11                        
aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                          seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                      out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i) yteam1(i)],xpoints(:,j),ypoints(:,j));
                      T_F=sum(out.intAdjacencyMatrix);
                      [distance(j), ins(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distance(j))<1 || abs(distancefff(j))<1
                        PR(i)=0;
                     end
                    end
                     if  PR(i)==1
                     index(ins==0)=[];
                     distance(ins==0)=[];
                     ins(ins==0)=[];
                     right=find(distance(:)<0);
                     left=find(distance(:)>0);
                     if isempty(right)
                        distanceright(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                        distanceright(:,2)=0;
                     end
                     if isempty(left)
                         distanceleft(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                         distanceleft(:,2)=0;
                     end
                     if ~isempty(left)
                         distanceleft(:,2)=distance(distance(:)>0);
                         distanceleft(:,1)=index(distance(:)>0);
                     end
                     if ~isempty(right)
                          distanceright(:,1)=index(distance(:)<0);
                          distanceright(:,2)=distance(distance(:)<0);
                     end
                     distanceleft=sortrows(distanceleft,2);
                     distanceright=sortrows(distanceright,2,'descend');
                     Def(h)=distanceright(1,1);
                     Def(h+1)=distanceleft(1,1);
                     outfieldplayers(i)=outfield(i)-outfield(ballowner);
                     h=h+2;
                     distanceright=[];
                     distanceleft=[];
                     index=1:11;
                     ins(1:11)=0;
                     distance(1:11)=0;

                     end

                end
                     if i~=ballowner && outfield(ballowner)==outfield(i) && (i~=1 || xteam1(ballowner)<57.4150)
                     PR(i)=3;
                  for j=1:11                        
aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                          seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                      out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i) yteam1(i)],xpoints(:,j),ypoints(:,j));
                      T_F=sum(out.intAdjacencyMatrix);
                      [distance(j), ins(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distance(j))<1 || abs(distancefff(j))<1
                        PR(i)=0;
                     end
                  end
                     if  PR(i)==3
                     right=find(distance(:)<0);
                     left=find(distance(:)>0);
                     if isempty(right)
                        distanceright(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                        distanceright(:,2)=0;
                     end
                     if isempty(left)
                         distanceleft(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                         distanceleft(:,2)=0;
                     end
                     if ~isempty(left)
                         distanceleft(:,2)=distance(distance(:)>0);
                         distanceleft(:,1)=index(distance(:)>0);
                     end
                     if ~isempty(right)
                          distanceright(:,1)=index(distance(:)<0);
                          distanceright(:,2)=distance(distance(:)<0);
                     end
                     distanceleft=sortrows(distanceleft,2);
                     distanceright=sortrows(distanceright,2,'descend');
                     Def(h)=distanceright(1,1);
                     Def(h+1)=distanceleft(1,1);
                     h=h+2;
                     outfieldplayers(i)=outfield(i)-outfield(ballowner);
                     distanceright=[];
                     distanceleft=[];
                     index=1:11;
                     ins(1:11)=0;
                     distance(1:11)=0;
                     end

                     end
                     if i~=ballowner && outfield(ballowner)>outfield(i)  && (i~=1 || xteam1(ballowner)<57.4150)
                     PR(i)=4;
                     for j=1:11                        
aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                          seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                      out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i) yteam1(i)],xpoints(:,j),ypoints(:,j));
                      T_F=sum(out.intAdjacencyMatrix);
                      [distance(j), ins(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i) yteam1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distance(j))<1 || abs(distancefff(j))<1
                        PR(i)=0;
                     end
                    end
                     if  PR(i)==4
                 index(ins==0)=[];
                     distance(ins==0)=[];
                     ins(ins==0)=[];
                     right=find(distance(:)<0);
                     left=find(distance(:)>0);
                     if isempty(right)
                        distanceright(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                        distanceright(:,2)=0;
                     end
                     if isempty(left)
                         distanceleft(:,1)=(xteam1(ballowner)+ xteam1(i))/2;
                         distanceleft(:,2)=0;
                     end
                     if ~isempty(left)
                         distanceleft(:,2)=distance(distance(:)>0);
                         distanceleft(:,1)=index(distance(:)>0);
                     end
                     if ~isempty(right)
                          distanceright(:,1)=index(distance(:)<0);
                          distanceright(:,2)=distance(distance(:)<0);
                     end
                     distanceleft=sortrows(distanceleft,2);
                     distanceright=sortrows(distanceright,2,'descend');
                     Def(h)=distanceright(1,1);
                     Def(h+1)=distanceleft(1,1);
                     h=h+2;
                     outfieldplayers(i)=outfield(i)-outfield(ballowner);
                     distanceright=[];
                     distanceleft=[];
                     index=1:11;
                     ins(1:11)=0;
                     distance(1:11)=0;
                     end

                     end
                     if i~=ballowner && outfield(ballowner)<Foutfield(i)  && sqrt(rx1(i).^2+ry1(i).^2)>2 && (i~=1 || xteam1(ballowner)<57.4150)
                     PRF(i)=1;
                     for j=1:11
  aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i)+rx1(i) yteam1(i)+ry1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distanceF(j), insf(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distanceF(j))<1 || abs(distancefff(j))<1
                        PRF(i)=0;
                     end
                     end 
                     if PRF(i)==1
                     indexf(insf==0)=[];
                     distanceF(insf==0)=[];
                     insf(insf==0)=[];
                     rightf=find(distanceF(:)<0);
                     leftf=find(distanceF(:)>0);
                     if isempty(rightf)
                       distancerightF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                       distancerightF(:,2)=0;
                     end
                     if isempty(leftf)
                         distanceleftF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                         distanceleftF(:,2)=0;
                     end
                     if ~isempty(leftf)
                         distanceleftF(:,2)=distanceF(distanceF(:)>0);
                         distanceleftF(:,1)=indexf(distanceF(:)>0);
                     end
                     if ~isempty(rightf)
                          distancerightF(:,1)=indexf(distanceF(:)<0);
                          distancerightF(:,2)=distanceF(distanceF(:)<0);
                     end
                     distanceleftF=sortrows(distanceleftF,2);
                     distancerightF=sortrows(distancerightF,2,'descend');
                     FDef(l)=distancerightF(1,1);
                     FDef(l+1)=distanceleftF(1,1);
                     l=l+2;
                     distancerightF=[];
                     distanceleftF=[];
                     indexf=1:11;
                     Foutfieldplayers(i)=Foutfield(i)-outfield(ballowner);
                     insf(1:11)=0;
                     distanceF(1:11)=0;
                     end

                     end
                     if i~=ballowner && outfield(ballowner)==Foutfield(i)   && sqrt(rx1(i).^2+ry1(i).^2)>2 && (i~=1 || xteam1(ballowner)<57.4150)
                     PRF(i)=3;
                     for j=1:11
  aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);

                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i)+rx1(i) yteam1(i)+ry1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distanceF(j), insf(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distanceF(j))<1 || abs(distancefff(j))<1
                        PRF(i)=0;
                     end
                     end 
                     if  PRF(i)==3
                     rightf=find(distanceF(:)<0);
                     leftf=find(distanceF(:)>0);
                     if isempty(rightf)
                       distancerightF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                       distancerightF(:,2)=0;
                     end
                     if isempty(leftf)
                         distanceleftF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                         distanceleftF(:,2)=0;
                     end
                     if ~isempty(leftf)
                         distanceleftF(:,2)=distanceF(distanceF(:)>0);
                         distanceleftF(:,1)=indexf(distanceF(:)>0);
                     end
                     if ~isempty(rightf)
                          distancerightF(:,1)=indexf(distanceF(:)<0);
                          distancerightF(:,2)=distanceF(distanceF(:)<0);
                     end
                     distanceleftF=sortrows(distanceleftF,2);
                     distancerightF=sortrows(distancerightF,2,'descend');
                     FDef(l)=distancerightF(1,1);
                     FDef(l+1)=distanceleftF(1,1);
                     l=l+2;
                     Foutfieldplayers(i)=Foutfield(i)-outfield(ballowner);
                     distancerightF=[];
                     distanceleftF=[];
                     indexf=1:11;
                     insf(1:11)=0;
                     distanceF(1:11)=0;
                     end

                     end
                     if i~=ballowner && outfield(ballowner)>Foutfield(i)  && sqrt(rx1(i).^2+ry1(i).^2)>2 && (i~=1 || xteam1(ballowner)<57.4150)
                     PRF(i)=4;
                     for j=1:11
  aa(1:200,1)=xteam2(j);                             aa(1:200,2)=yteam2(j);
                            seg(1:200,1:4)=([aa finalx(:,j) finaly(:,j)]);
                        out=lineSegmentIntersect(seg,[xteam1(ballowner) yteam1(ballowner) xteam1(i)+rx1(i) yteam1(i)+ry1(i)],xpoints(:,j),ypoints(:,j));
                        T_F=sum(out.intAdjacencyMatrix);
                      [distanceF(j), insf(j)]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j) yteam2(j)]);  
                      [distancefff(j), ~]=distance_passline([xteam1(ballowner) yteam1(ballowner)],[xteam1(i)+rx1(i) yteam1(i)+ry1(i)],[xteam2(j)+rx2(j) yteam2(j)+ry2(j)]);  
                     if sum(T_F)~=0 || abs(distanceF(j))<1 || abs(distancefff(j))<1
                        PRF(i)=0;
                     end
                     end
                     if PRF(i)==4
                 indexf(insf==0)=[];
                     distanceF(insf==0)=[];
                     insf(insf==0)=[];
                     rightf=find(distanceF(:)<0);
                     leftf=find(distanceF(:)>0);
                     if isempty(rightf)
                       distancerightF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                       distancerightF(:,2)=0;
                     end
                     if isempty(leftf)
                         distanceleftF(:,1)=(xteam1(ballowner)+ (xteam1(i)+rx1(i)))/2;
                         distanceleftF(:,2)=0;
                     end
                     if ~isempty(leftf)
                         distanceleftF(:,2)=distanceF(distanceF(:)>0);
                         distanceleftF(:,1)=indexf(distanceF(:)>0);
                     end
                     if ~isempty(rightf)
                          distancerightF(:,1)=indexf(distanceF(:)<0);
                          distancerightF(:,2)=distanceF(distanceF(:)<0);
                     end
                     distanceleftF=sortrows(distanceleftF,2);
                     distancerightF=sortrows(distancerightF,2,'descend');
                     FDef(l)=distancerightF(1,1);
                     FDef(l+1)=distanceleftF(1,1);
                     l=l+2;
                     distancerightF=[];
                     distanceleftF=[];
                     indexf=1:11;
                     Foutfieldplayers(i)=Foutfield(i)-outfield(ballowner);
                     insf(1:11)=0;
                     distanceF(1:11)=0;
                     end

                     end
             end   

 
            end
end
PR=PR';
PRF=PRF';
Def=Def';
FDef=FDef';  
end
