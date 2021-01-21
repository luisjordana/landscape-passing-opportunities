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
seriesvelocity = [0 1 2 3 4 5 6 7 8];
seriesangle = [360 280 240 160 100 90 80 60 40];

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
    
    % PR = 1, when a player is outfielding more opponents than the
    % ball carrier
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        outfield(:,pp)>ball_carrier_outfield;
    PR(ix,pp) = 1;
    
    % PRF = 1, when a player is outfielding more opponents than the
    % ball carrier
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        Foutfield(:,pp)>ball_carrier_outfield & ...
        Team_A.v_total{:,pp} > 2;
    PRF(ix,pp) = 1;
    
    % PR = 3, support passes 
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        outfield(:,pp) == ball_carrier_outfield & ...
        (pp > 1 | ball_carrier_x > 57.4150);
    PR(ix,pp) = 3;
    
    % PRF = 3, support passes
    ix = ball.possession_team_id == 1 & ...
        ~isnan(ball.possession_player_id2) & ...
        ball.possession_player_id2 ~= pp & ...
        Foutfield(:,pp) == ball_carrier_outfield & ...
        (pp > 1 | ball_carrier_x > 57.4150) & ...
        Team_A.v_total{:,pp} > 2;
    PR(ix,pp) = 3;
    
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

%Now we prebuild the variables PR (the one that will contain what player
%has the ball, and which can receive each type of pass), PRF (The same for
%passes that are to the future position of the player), DEF (nearest defender on its
%defect the mid position in the sideline between the receiver and the
%passer), FDEF (same for passes to future position), outfield and Foutfield
%give the number of outfield of each player for its current position and
%future position. This doesn't play any role on the build up of the heatmap
%or video but helps with seen if the algorithm is working adequately.
PR(1:length(ix_plays),1:11)=0;
PRF(1:length(ix_plays),1:11)=0;
Def(1:length(ix_plays),1:20)=0;
FDef(1:length(ix_plays),1:20)=0;
outfield(1:length(ix_plays),1:11)=0;
Foutfield(1:length(ix_plays),1:11)=0;
% To see the information on how the algorithm is working please refer to
% the algorithm function.
for i=1:length(ix_plays)
    if ballowner(i)~=0
        [PR(i,:), PRF(i,:), Def(i,:), FDef(i,:), outfield(i,:), Foutfield(i,:)] = ...
            passing_linesD(x_TeamA(i,:), y_TeamA(i,:), x_TeamB(i,:), ...
            y_TeamB(i,:),vx_TeamA(i,:),vy_TeamA(i,:),vx_TeamB(i,:),...
            vy_TeamB(i,:), newseries_TeamB, teamballowner(i), ballowner(i),...
            [0 0 0],1,distanceBT(i,:),distanceFBT(i,:),distanceOT(i,:));
    end
end


% As the heatmap takes a lot of time to be build i usually do one half at a
% time by simply changing the part were the algorithm is run.

% PR(1:length(Jgadas2),1:11)=0;
% PRF(1:length(Jgadas2),1:11)=0;
% Def(1:length(Jgadas2),1:20)=0;
% FDef(1:length(Jgadas2),1:20)=0;
% outfield(1:length(Jgadas2),1:11)=0;
% Foutfield(1:length(ix_plays),1:11)=0;
% for i=1:length(Jgadas2)
%     if ballowner(Jgadas2(i))~=0
%     [PR(i,:), PRF(i,:), Def(i,:), FDef(i,:),outfield(i,:), Foutfield(i,:)]=passing_linesD(x_TeamA(Jgadas2(i),:), y_TeamA(Jgadas2(i),:), x_TeamB(Jgadas2(i),:), y_TeamB(Jgadas2(i),:),vx_TeamA(Jgadas2(i),:),vy_TeamA(Jgadas2(i),:),vx_TeamB(Jgadas2(i),:),vy_TeamB(Jgadas2(i),:), newseries_TeamB, teamballowner(Jgadas2(i)), ballowner(Jgadas2(i)),[0 0 0],2);
%     end
% end

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
results4.PR=PR;
results4.PRF=PRF;
results4.Def=Def;
results4.FDef=FDef;
results4.counter=counter;
results4.counterf=counterf;
results4.index=index;
results4.indexf=indexf;
results4.x_TeamA=x_TeamA;
results4.y_TeamA=y_TeamA;
results4.x_TeamB=x_TeamB;
results4.y_TeamB=y_TeamB;
results4.vx_TeamA=vx_TeamA;
results4.vy_TeamA=vy_TeamA;
results4.vx_TeamB=vx_TeamB;
results4.vy_TeamB=vy_TeamB;
results4.ballowner=ballowner;
results4.teamballowner=teamballowner;
results4.xball=xball;
results4.yball=yball;
results4.outfield=outfield;
results4.Foutfield=Foutfield;

%% save and load
save('final_results.mat', 'results4')