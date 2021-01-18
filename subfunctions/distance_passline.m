function [distance, Ins]=distance_passline(Bow,Pr,Defender)
%function that calculates de distance of defenders to the pass line. Also
%detects in what side the defenders are, and if the defenders are inside of
%the passline (calculating then the distance using the crossproduct) or it
%is outside using a simple point to point distance definition. To detect if
%a point is inside the passline it uses an angular definition. (see picture
%attach to email call angular). basically if players are inside the segment
%then the angle from them to the ballowner and ballreceiver are lower than 90ª
%if not one is bigger than 90º.

Ins=0;
RB= Bow-Pr;
BR=Pr-Bow;
RB(3)=0;
BR(3)=0;
Bopt=Bow-Defender;
Bopt(3)=0;
Rpt=Pr-Defender;
Rpt(3)=0;
Degrees = atan2d(norm(cross(Bopt,RB)),dot(Bopt,RB));
Degrees2 = atan2d(norm(cross(Rpt,BR)),dot(Rpt,BR)); 

if Degrees<90 && Degrees2<90 && ~ Degrees==0
    b=Defender-Pr;
    b(3)=0;
    distance = sqrt(sum(cross(RB,b,2).^2,2)) ./ sqrt(sum(RB.^2,2));
    crossproduct= (Pr(2)-Bow(2))*(Defender(1)-Pr(1))-(Defender(2)-Pr(2))*(Pr(1)-Bow(1));
    Ins=1;
end
if Degrees==90 || Degrees2==90 
    b=Defender-Pr;
    b(3)=0;
    distance = sqrt(sum(cross(RB,b,2).^2,2)) ./ sqrt(sum(RB.^2,2));
    crossproduct= (Pr(2)-Bow(2))*(Defender(1)-Pr(1))-(Defender(2)-Pr(2))*(Pr(1)-Bow(1));
    Ins=1;
end
if Degrees>90 || Degrees2>90
    Pdistance(1)=sqrt((Bow(1)-Defender(1))^2 + (Bow(2)-Defender(2))^2);
    Pdistance(2)=sqrt((Pr(1)-Defender(1))^2 + (Pr(2)-Defender(2))^2);
    distance=min(Pdistance);
    crossproduct= (Pr(2)-Bow(2))*(Defender(1)-Pr(1))-(Defender(2)-Pr(2))*(Pr(1)-Bow(1));
    Ins=0;
end
if Degrees==0 && Bow(1)<Defender(1) && Pr(1)>Defender(1)
    distance=0;
    crossproduct= 0;
    Ins=0;
end
if Degrees==0 && (Bow(1)>Defender(1) || Pr(1)<Defender(1))
    Pdistance(1)=sqrt((Bow(1)-Defender(1))^2 + (Bow(2)-Defender(2))^2);
    Pdistance(2)=sqrt((Pr(1)-Defender(1))^2 + (Pr(2)-Defender(2))^2);
    distance=min(Pdistance);
    crossproduct= (Pr(2)-Bow(2))*(Defender(1)-Pr(1))-(Defender(2)-Pr(2))*(Pr(1)-Bow(1));
    Ins=0;
end
    if crossproduct==0           
        crossproduct= 0;
    end
    if crossproduct<0
    distance=distance*-1;
        if Ins~=0
        Ins=Ins*-1;
        end
    end
end