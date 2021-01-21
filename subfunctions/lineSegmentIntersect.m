% Source: https://www.mathworks.com/matlabcentral/fileexchange/27205-fast-line-segment-intersection
% This code was adapted to evaluate how long a defender and the ball take
% to reach a potential interception point, and cancel interceptions where
% the defender takes longer than the ball to reach that point
% XYI and XY2 naming was defined in the original script, and in this
% project correspond to the coverage lines from a defender and the passing
% line between the ball carrier and a potential receiver, respectively
function intercept_bool = lineSegmentIntersect(XY1,XY2,def_velocity)
%LINESEGMENTINTERSECT Intersections of line segments.
%   OUT = LINESEGMENTINTERSECT(XY1,XY2) finds the 2D Cartesian Coordinates of
%   intersection points between the set of line segments given in XY1 and XY2.
%
%   XY1 and XY2 are N1x4 and N2x4 matrices. Rows correspond to line segments. 
%   Each row is of the form [x1 y1 x2 y2] where (x1,y1) is the start point and 
%   (x2,y2) is the end point of a line segment.

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

XY2_t = XY2';

X3 = repmat(XY2_t(1,:),n_rows_1,1);
X4 = repmat(XY2_t(3,:),n_rows_1,1);
Y3 = repmat(XY2_t(2,:),n_rows_1,1);
Y4 = repmat(XY2_t(4,:),n_rows_1,1);

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

% boolean, where false (0) indicates that a infinitely long defending 
% line, originating from the defending player, cannot intercept a given 
% passing line, while true (1) the contrary.
intercept_bool = INT_B;

intercept_x =  INT_X .* INT_B;
intercept_y =  INT_Y .* INT_B;

defender_x = XY1(1,1);
defender_y = XY1(1,2);

% assumes that ball position = ball owner position
ball_x = XY2(1,1);
ball_y = XY2(1,2);

% if no extended defensive line intercepts the passing line
if sum(intercept_bool) == 0
    intercept_bool = 0;
    return
end

% the defensive coverage segments which cross the passing line 
ix_intercept = intercept_bool == 1;

% distance between a given defender and the defensive coverage-passing line
% interception 
dist_def_to_interception = sqrt((defender_x - intercept_x(ix_intercept)).^2 + ...
    (defender_y - intercept_y(ix_intercept)).^2);

% time for a given defender to intercept a passing line
time_def_to_interception = dist_def_to_interception / def_velocity;

% distance between the ballowner (the starting point of the pass) and the
% possible pass interception by a given defender
dist_ball_to_interception = sqrt((ball_x - intercept_x(ix_intercept)).^2 + ...
    (ball_y - intercept_y(ix_intercept)).^2);

% assumed ball speed
ball_speed = 10;

% time for the bal to reach the possible defender interception
time_ball_to_interception = dist_ball_to_interception / ball_speed;

% no-interception: if the defender takes longer than the ball to reach a 
% potential interception point
ix_no_intercept = time_def_to_interception > time_ball_to_interception;

% corrects this boolean, now having considered the effective time a given
% defender takes to reach the calculated interception poin
intercept_bool(ix_intercept(ix_no_intercept)) = 0;

% converts boolean series to a single indicator
% if no line intercepts pass: 0 > 1 => intercept_bool = 0
% if at least one line intercepts pass: N >= 1 => intercept_bool = 1
intercept_bool = min(sum(intercept_bool),1);

end