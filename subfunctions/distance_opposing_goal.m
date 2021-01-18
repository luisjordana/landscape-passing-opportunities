function [distanceBT,distanceFBT,distanceOT] = ...
    distance_opposing_goal(ix_plays,Team_A,Team_B)
% c.f. https://www.qc.edu.hk/math/Advanced%20Level/Point_to_line.htm

% Team_B goal coordinates
left_post = [0 40.845]; right_post = [0 33.5250];

% variables initialization
% explain
distanceBT = nan(length(ix_plays),11);
distanceOT = nan(length(ix_plays),11);
distanceFBT = nan(length(ix_plays),11);

% runs for the 11 players of each team
for pp = 1:11
    % goal line vector
    % 3D (with z=0) to allow for cross-product implementation
    LR = [right_post-left_post 0];
    
    % distance for players from ball-owning team
    % % % % % % % % % % % % % % % % % % % %
    % player-left post vector
    % 3D (with z=0) to allow for cross-product implementation
    LP = [Team_A.x{:,pp} Team_A.y{:,pp} zeros(length(ix_plays),1)];
    distanceBT(:,pp) = ...
        vecnorm(cross(repmat(LR,length(ix_plays),1),LP,2),2,2)/norm(LR);
    
    % distance for players from ball-owning team (future positioning)
    % % % % % % % % % % % % % % % % % % % %
    LP = [Team_A.x{:,pp} + Team_A.v_x{:,pp} ...
        Team_A.y{:,pp} + Team_A.v_y{:,pp} zeros(length(ix_plays),1)];
    distanceFBT(:,pp) = ...
        vecnorm(cross(repmat(LR,length(ix_plays),1),LP,2),2,2)/norm(LR);
    
    % distance for players from defending teamam
    % % % % % % % % % % % % % % % % % % % %
    LP = [Team_B.x{:,pp} Team_B.y{:,pp} zeros(length(ix_plays),1)];
    distanceOT(:,pp) = ...
        vecnorm(cross(repmat(LR,length(ix_plays),1),LP,2),2,2)/norm(LR);
end
end