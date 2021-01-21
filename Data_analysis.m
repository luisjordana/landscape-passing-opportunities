% cleans command window + clears variables and plots in cache
clc; clear variables; close all;

%% Consider subfolders for data and functions

% Determine where your m-file's folder is.
folder = fileparts(which(mfilename));
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

%% read data
load('preprocessed_inputs.mat',...
    'Team_A','Team_B','ball',...
    'vt_TeamA_prct99_95','vt_TeamB_prct99_95')

% pitch positions
position_list = {'GK','LB','CB1','CB2','RB','LW','CM','MF1','MF2','RW','ST'};

% number of data rows (or timesteps considered in this code)
num_data_rows = size(Team_A.x,1);

%% Analysis
% These indices correspond to 5 Hz data for the plays under study using the
% 3-min long dataset made available in this repository
ix_plays=[1:5:1125 2600:5:3150];

%% distance of each player to Team_B's goal (focus is Team_A offense)
[distanceBT,distanceFBT,distanceOT] = ...
    distance_opposing_goal(ix_plays,Team_A,Team_B);

%% For each attacking player how many opposing players are outfielded (?)
% Again, looks from an offensive perspective to Team_A 
outfield = nan(num_data_rows,11);
Foutfield = nan(num_data_rows,11);

% Using the distance to the goal line, we calculate the number of players 
% outfielded by each player from Team_A. runs for the 11 players
for pp = 1:11
    outfield(:,pp) = sum(distanceBT(:,pp) < distanceOT,2);
    Foutfield(:,pp) = sum(distanceFBT(:,pp) < distanceOT,2);
end

%% Calculating defensive coverage area for each player from defending team^M
% This coverage area is inspired on the work of Grehaigne et al. (1997)
% https://www.tandfonline.com/doi/pdf/10.1080/026404197367416
% In essence, this study evaluates a player's ability to change direction
% based on his running speed. Thus, by considering the angle range and the
% player's current velocity, a coverage area can be estimated.
% original velocity and corresponding angle of rotation
series_velocity = [0 1 2 3 4 5 6 7 8];
series_angle = [360 280 240 160 100 90 80 60 40];

% a 101-point resolution is considered
ref_velocity_values = 0:8/100:8;
ref_angles_values = interp1(series_velocity,series_angle,ref_velocity_values)';

% Calculating angle range for each player in each instant (only for the
% defending team)
Team_B.v_angle_plus = nan(size(Team_B.v_angle));
Team_B.v_angle_minus = nan(size(Team_B.v_angle));

for pp = 1:11
    % Adapts to the maximum speed of each player during the game under study
    custom_speed_series = ...
        [0:max(Team_B.v_total{:,pp})/100:max(Team_B.v_total{:,pp})];
    
    % index corresponding to the most similar velocity value from
    % "ref_velocity_values" array for each timestep for each defender
    temp = custom_speed_series-Team_B.v_total{:,pp};
    [~,ix_sim_speed] = min(abs(temp),[],2);
    
    Team_B.v_angle_plus(:,pp) = Team_B.v_angle{:,pp} + ...
        ref_angles_values(ix_sim_speed)/2;
    Team_B.v_angle_minus(:,pp) = Team_B.v_angle{:,pp} - ...
        ref_angles_values(ix_sim_speed)/2;
    Team_B.v_angle_range(:,pp) = ref_angles_values(ix_sim_speed);
end
% Convert to table format
Team_B.v_angle_range = ...
    array2table(Team_B.v_angle_range,'VariableNames',position_list);
Team_B.v_angle_plus = ...
    array2table(Team_B.v_angle_plus,'VariableNames',position_list);
Team_B.v_angle_minus = ...
    array2table(Team_B.v_angle_minus,'VariableNames',position_list);

%% relevant ballowner variables
% These values will be used later on
ball_carrier_x = nan(num_data_rows,1);
ball_carrier_outfield = nan(num_data_rows,1);
for pp = 1:11
    ix = ball.possession_player_id2 == pp & ...
        ~isnan(outfield(:,pp));
    ball_carrier_x(ix) = Team_A.x{ix,pp};
    ball_carrier_outfield(ix) = outfield(ix,pp);
end

% defines pass type (penetrative, support, retreat) based on number of
% opposing players that each player of Team_A outfields when compared to 
% the ball owner play (working as a proxy of relative positioning between
% players)
PR = nan(size(Team_B.x));
PRF = nan(size(Team_B.x));

% runs for every offensive player
for pp = 1:11
    % PR(F) = 2, the player is the ballowner
    ix = ball.possession_team_id == 1 & ball.possession_player_id2 == pp;
    PR(ix,pp) = 2;
    PRF(ix,pp) = 2;
    
    % PR = 1, penetrative pass
    % the receiving player is outfielding more opponents than the ball carrier
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        outfield(:,pp)>ball_carrier_outfield;
    PR(ix,pp) = 1;
    
    % PRF = 1  (considers Foutfield)
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        Foutfield(:,pp)>ball_carrier_outfield & ...
        Team_A.v_total{:,pp} > 2;
    PRF(ix,pp) = 1;
    
    % PR = 3, support passes 
    % the receiving player is outfielding more opponents than the ball carrier
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        outfield(:,pp) == ball_carrier_outfield & ...
        (pp > 1 | ball_carrier_x > 57.4150);
    PR(ix,pp) = 3;
    
    % PRF = 3 (considers Foutfield), support passes
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        Foutfield(:,pp) == ball_carrier_outfield & ...
        (pp > 1 | ball_carrier_x > 57.4150) & ...
        Team_A.v_total{:,pp} > 2;
    PRF(ix,pp) = 3;
    
    % PR = 4, retreat passes 
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        outfield(:,pp) < ball_carrier_outfield & ...
        (pp > 1 | ball_carrier_x > 57.4150);
    PR(ix,pp) = 4;
    
    % PRF = 4, retreat passes
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        Foutfield(:,pp) < ball_carrier_outfield & ...
        (pp > 1 | ball_carrier_x > 57.4150) & ...
        Team_A.v_total{:,pp} > 2;
    PRF(ix,pp) = 4;
end

% calculates coverage range for every player from the defending team
angle_points = cell(1,11);
def_coverage_x = cell(1,11);
def_coverage_y = cell(1,11);

for pp = 1:11
    % To vectorize this calculation, the problem is formulated as 
    % angle_coverage = starting_angle + coef*angle_range_series, with this
    % range_series being a discretized 200 points-long array from 0 to 
    % angle_range (using linspace, replicated for each data row, and diag
    % to be able to multiply a vector (angle_range) with the linspace matrix.
    % Source: https://stackoverflow.com/questions/40120585/matlab-multiply-each-row-in-matrix-by-different-number
    angle_points{pp} = Team_B.v_angle_minus{:,1} + ...
        diag(Team_B.v_angle_range{:,pp})*repmat(linspace(0,1,200),num_data_rows,1);
    
    % calculates the end point of line segments that start from the defender
    % position and follow the range of directions the player can move 
    % (depending on his velocity). an exaggerated velocity is considered so
    % that the line segments reach the pitch boundaries (it is okay if they
    % are even surpassed). This will be used to detect possible interceptions
    % with a given passing line. Later on, the time needed by the defender 
    % for that interception will be calculated.
    inf_velocity = 9999999;
    def_coverage_x{pp} = Team_B.x{:,pp} + ...
        inf_velocity * sind(angle_points{pp});
    def_coverage_y{pp} = Team_B.y{:,pp} + ...
        inf_velocity * cosd(angle_points{pp});
end

% for indexing (later used)
h = 1; 
for t = 1:length(ix_plays)
    t
   % skips if Team_A is not the ball owner or there is no ball owner at all
   ball_owner = ball.possession_player_id2(t);
    if ball.possession_team_id(t) ~=1 || isnan(ball_owner)
        continue
    end
    
    % position of ball owner
    ball_owner_pos = ...
        [Team_A.x{t,ball_owner} Team_A.y{t,ball_owner}];
    
    % runs every potential pass-receiving player from Team_A
    for pp1 = 1:11        
        % skips player if he is the ball_owner (PR=2)
        if PR(t,pp1) == 2
            continue
        end
                      
        % runs present (1) and future (next second, 2) possibilities, by
        % considering either present or future positioning
        for time = [1 2] 
            % runs every opposing player, assessing their defensive coverage
            for pp2 = 1:11
                % Line segments extending from each defensive player
                def_lines(:,1:4) = ...
                    [repmat([Team_B.x{t,pp2} Team_B.y{t,pp2}],200,1) ...
                    def_coverage_x{pp2}(t,:)' def_coverage_y{pp2}(t,:)'];
                
                % the variables below only need to be calculated once per
                % player in attacking team (pp1)
                if pp2 == 1
                    % position of receiving player
                    receiver_pos = [Team_A.x{t,pp1} Team_A.y{t,pp1}];
                    % correspoding passing line segment
                    passing_line = [ball_owner_pos receiver_pos];
                
                    % if future positioning is being considered
                    if time == 2
                        receiver_pos = receiver_pos + ...
                            [Team_A.v_x{t,pp1} Team_A.v_y{t,pp1}];
                    end
                end
                
                % current and future defending player position
                defender_pos = [Team_B.x{t,pp2} Team_B.y{t,pp2}];
                defender_Fpos = [Team_B.x{t,pp2} + Team_B.v_x{t,pp2}...
                    Team_B.y{t,pp2} + Team_B.v_y{t,pp2}];
            
                % The defensive line segments are used for each opposing 
                % player to calculate if that player can arrive to a passing
                % line before the ball reaches a potential receiving player 
                intercept_bool = lineSegmentIntersect(def_lines,passing_line,...
                    Team_B.v_total{t,pp2});
                
                % distance between the defender and the passing line
                % ins indicats if the passing line is intercepted
                % depending on counter "time", receiver_pos corresponds to
                % current or future positioning
                [distance(pp2), ins(pp2)] = distance_passline(...
                    ball_owner_pos, receiver_pos, defender_pos);
                
                % same as distance, but consideres defender future
                % positioning
                [distanceF(pp2), insF(pp2)] = distance_passline(...
                    ball_owner_pos, receiver_pos, defender_Fpos);
                                
                % if the passing line is intercepted, PR = 0
                if time == 1 && (intercept_bool == 1 ||  ...
                        abs(distance(pp2))<1 || abs(distanceF(pp2))<1)
                    PR(t,pp1) = 0;
                    continue
                elseif time == 2 && (intercept_bool == 1 || ...
                        abs(distance(pp2))<1 || abs(distanceF(pp2))<1)
                    PRF(t,pp1) = 0;
                    continue
                end
            end
                
            % if the pass can't be intercepted, the defensive players that
            % are nearer in each side are identified. In the absence of a
            % defender on a given (or both) side(s), the nearest point in
            % the sideline is considered.
            index = 1:11;
            
            % ???
            ix = ins == 0;
            index(ix) = [];
            distance(ix) = [];
            ins(ix) = [];
            
            right = find(distance(:)<0);
            left = find(distance(:)>0);
            
            % ????
            if isempty(right)
                distanceright(:,1) = ...
                    (Team_A.x{t,ball_owner} + Team_A.x{t,pp1})/2;
                distanceright(:,2) = 0;
            else
                distanceright(:,1) = index(distance(:)<0); % ????
                distanceright(:,2) = distance(distance(:)<0);
            end
            
            % ????
            if isempty(left)
                distanceleft(:,1) = (Team_A.x{t,ball_owner} + Team_A.x{t,pp1})/2;
                distanceleft(:,2) = 0;
            else
                distanceleft(:,2)=distance(distance(:)>0);
                distanceleft(:,1)=index(distance(:)>0);
            end
            
            % sorts distances from closest to farthest
            distanceleft = sortrows(distanceleft,2);
            distanceright = sortrows(distanceright,2,'descend');
          
            if time == 1
                % ????
                Def(t,h) = distanceright(1,1);
                Def(t,h+1) = distanceleft(1,1);
            else
            % ????
                FDef(t,h) = distanceright(1,1);
                FDef(t,h+1) = distanceleft(1,1);
            end
            % ????
            h=h+2;
            
            % ????
            outfieldplayers(t) = outfield(t)-outfield(ball_owner);
            
            % reset
            distanceright=[]; distanceleft=[];
            index=1:11;
            ins(1:11)=0;
            distance(1:11)=0;
        end
    end
end

%These counters and index are created to buildn the
counter(1:length(PR))=0;
counterf(1:length(PR))=0;
index(1:9,1:length(PR))=0;
indexf(1:9,1:length(PR))=0;

for i=1:length(PR)
    counter(:,i)=length(find(PR(i,:)==1 | PR(i,:)==3 | PR(i,:)==4));
    counterf(:,i)=length(find(PRF(i,:)==1 | PRF(i,:)==3 | PRF(i,:)==4));
end

for i=1:length(PR)
    if counter(i)~=0
        index(1:counter(i),i)=find(PR(i,:)==1 | PR(i,:)==3 | PR(i,:)==4);
    end
    if counterf(i)~=0
        indexf(1:counterf(i),i)=find(PRF(i,:)==1 | PRF(i,:)==3 | PRF(i,:)==4);
    end
end

% store outputs
results4.ix_plays = ix_plays;
results4.PR = PR;
results4.PRF = PRF;
results4.Def = Def;
results4.FDef = FDef;
results4.counter = counter;
results4.counterf = counterf;
results4.index = index;
results4.indexf = indexf;
results4.x_TeamA = Team_A.x;
results4.y_TeamA = Team_A.y;
results4.x_TeamB = Team_B.x;
results4.y_TeamB = Team_B.y;
results4.vx_TeamA = Team_A.v_x;
results4.vy_TeamA = Team_A.v_y;
results4.vx_TeamB = Team_B.v_x;
results4.vy_TeamB = Team_B.v_y;
results4.ballowner = ball.possession_player_id2;
results4.teamballowner = ball.possession_team_id;
results4.xball = ball.x;
results4.yball = ball.y;
results4.outfield = outfield;
results4.Foutfield = Foutfield;

%% save and load
save('final_results.mat', 'results4')