function out = lineSegmentIntersect(XY1,XY2, Xpuntosintermedios,yPuntosintermedios)
%LINESEGMENTINTERSECT Intersections of line segments.
%   OUT = LINESEGMENTINTERSECT(XY1,XY2) finds the 2D Cartesian Coordinates of
%   intersection points between the set of line segments given in XY1 and XY2.
%
%   XY1 and XY2 are N1x4 and N2x4 matrices. Rows correspond to line segments. 
%   Each row is of the form [x1 y1 x2 y2] where (x1,y1) is the start point and 
%   (x2,y2) is the end point of a line segment.

%
%   OUT is a structure with fields:
%
%   'intAdjacencyMatrix' : N1xN2 indicator matrix where the entry (i,j) is 1 if
%       line segments XY1(i,:) and XY2(j,:) intersect.
%
%   'intMatrixX' : N1xN2 matrix where the entry (i,j) is the X coordinate of the
%       intersection point between line segments XY1(i,:) and XY2(j,:).
%
%   'intMatrixY' : N1xN2 matrix where the entry (i,j) is the Y coordinate of the
%       intersection point between line segments XY1(i,:) and XY2(j,:).
%
%   'intNormalizedDistance1To2' : N1xN2 matrix where the (i,j) entry is the
%       normalized distance from the start point of line segment XY1(i,:) to the
%       intersection point with XY2(j,:).
%
%   'intNormalizedDistance2To1' : N1xN2 matrix where the (i,j) entry is the
%       normalized distance from the start point of line segment XY1(j,:) to the
%       intersection point with XY2(i,:).
%
%   'parAdjacencyMatrix' : N1xN2 indicator matrix where the (i,j) entry is 1 if
%       line segments XY1(i,:) and XY2(j,:) are parallel.
%
%   'coincAdjacencyMatrix' : N1xN2 indicator matrix where the (i,j) entry is 1 
%       if line segments XY1(i,:) and XY2(j,:) are coincident.
%
%   I modifiend this function to also include the mid points. This mid
%   points are then used (in case the area segments intersect with the passing line)
%   in the end part of the function to calculate if the players will arrive
%   to that point of the passing line before the ball or not. Also the ball
%   velocity is introduced here. 
%   
%-------------------------------------------------------------------------------

validateattributes(XY1,{'numeric'},{'2d','finite'});
validateattributes(XY2,{'numeric'},{'2d','finite'});

[n_rows_1,n_cols_1] = size(XY1);
[n_rows_2,n_cols_2] = size(XY2);

if n_cols_1 ~= 4 || n_cols_2 ~= 4
    error('Arguments must be a Nx4 matrices.');
end

%%% Prepare matrices for vectorized computation of line intersection points.
%-------------------------------------------------------------------------------
X1 = repmat(XY1(:,1),1,n_rows_2);
X2 = repmat(XY1(:,3),1,n_rows_2);
Y1 = repmat(XY1(:,2),1,n_rows_2);
Y2 = repmat(XY1(:,4),1,n_rows_2);

XY2 = XY2';

X3 = repmat(XY2(1,:),n_rows_1,1);
X4 = repmat(XY2(3,:),n_rows_1,1);
Y3 = repmat(XY2(2,:),n_rows_1,1);
Y4 = repmat(XY2(4,:),n_rows_1,1);

X4_X3 = (X4-X3);
Y1_Y3 = (Y1-Y3);
Y4_Y3 = (Y4-Y3);
X1_X3 = (X1-X3);
X2_X1 = (X2-X1);
Y2_Y1 = (Y2-Y1);

numerator_a = X4_X3 .* Y1_Y3 - Y4_Y3 .* X1_X3;
numerator_b = X2_X1 .* Y1_Y3 - Y2_Y1 .* X1_X3;
denominator = Y4_Y3 .* X2_X1 - X4_X3 .* Y2_Y1;

u_a = numerator_a ./ denominator;
u_b = numerator_b ./ denominator;

% Find the adjacency matrix A of intersecting lines.
INT_X = X1+X2_X1.*u_a;
INT_Y = Y1+Y2_Y1.*u_a;
INT_B = (u_a >= 0) & (u_a <= 1) & (u_b >= 0) & (u_b <= 1);
PAR_B = denominator == 0;
COINC_B = (numerator_a == 0 & numerator_b == 0 & PAR_B);

%%distance a punto determinado


% Arrange output.
out.intAdjacencyMatrix = INT_B;
out.intMatrixX = INT_X .* INT_B;
out.intMatrixY = INT_Y .* INT_B;
out.intNormalizedDistance1To2 = u_a;
out.intNormalizedDistance2To1 = u_b;
out.parAdjacencyMatrix = PAR_B;
out.coincAdjacencyMatrix= COINC_B;

for i=1:length(XY1(:,1)) % For the amount of segments we are studying (200 in our case)
   if INT_B(i)==1 %If the line cross the pass. 
      distance_to_interception=sqrt((XY1(i,1)-out.intMatrixX(i)).^2+(XY1(i,2)-out.intMatrixY(i)).^2); 
      %module of the vector from the position of the defender to the point where the line intersects with the
      % segment.
      distance_to_end_of_area=sqrt((XY1(i,1)-Xpuntosintermedios(i)).^2+(XY1(i,2)-yPuntosintermedios(i)).^2);
      %module of the vector from the position of the defender to the point where 
      %the area ends.
      time_of_interception=distance_to_interception/distance_to_end_of_area;
      % By dividing this modules we have the seconds the defender takes to
      % the interception.
      ballcarrier_to_interception=sqrt((XY2(1)-out.intMatrixX(i)).^2+(XY2(2)-out.intMatrixY(i)).^2);
      %module of the vector from the position of the ballcarrier to the point where 
      %the area ends.
      time_of_ball=ballcarrier_to_interception/10;
      % By dividing by 10 m/s we get the time the ball takes to arrive to
      % the interception.
      if time_of_interception>time_of_ball
          %if the player takes longer than the ball this value is set to 0,
          %if not is left in 1 meaning the ball was intercepted. 
          INT_B(i)=0;
      end
   end
   
end
out.intAdjacencyMatrix = INT_B;


end

