% script used to read, preprocess, and filter RAW data
% from the full data set, only three minutes of high-resolution data are
% stored, as to deal with data privacy issues

% this code is meant only to illustrate how the data is originally handled,
% as the user should start with the Data_analysis.m file, which reads the 
% preprocessed_inputs.mat file (the actual output of this code)

% running this script "as is" with the .csv files provided in GitHub will lead to possible
% errors/incosistencies, as this script assumes that the user has the full
% dataset

clc; clear variables; close all;

%% Consider subfolders for data and functions

% Determine where your m-file's folder is.
folder = fileparts(which(mfilename)); 
% Add that folder plus all subfolders to the path.
addpath(genpath(folder));

%% read data
% Team_details, 2 columns:
% id: team identifier.
% name: name of the team
filename = 'teams_details.csv';
team_details = readtable(filename);

% Events, 11 columns:
% start_x: where, in x, did the event start [units?]
% start_y: where, in y, did the event start [units?]
% end_x: where, in x, did the event end [units?]
% end_y: where, in y, did the event end [units?]
% event_type_id: type of event
% player_id: identifier of the player who performed the event.
% target_player_id: identifier of a second player who also participated in the event 
% (applicable only in event types (e.g. the player receiving a pass)
% start_frame: frame, in time, when the event started.
% end_frame: frame, in time, when the event ended.
% team_id: identifier of the participating player's team
% success: success or failure of a given event
% explain NaN's
filename = 'events.csv';
events = readtable(filename);

% Players positions
% frame: ????
% time: ????
% id: identifier of a given player
% x: position in x for a given player
% y: position in y for a given player
filename = 'players_positions_short.csv';
players_positions = readtable(filename);

% Players details, 8 columns
% player_id: Player identifier.
% team_id: team identifier.
% frame_start: Frame when the player enter the field.
% frame_end: When the player left the field. 
% The rest of the columns are irrelevant.
% position_line: ???
% position_wing: ???
filename = 'players_details.csv';
players_details = readtable(filename);

% Game details, 15 columns
% Only relevant columns are 5th and 6th  that tell us the dimensions of the field. 
% And the last eight that help us trim the data removing the irrelevant information.
% To be improved
filename = 'game_details.csv';
game_details = readtable(filename);

% Ball position & possessions, 5 columns
% frame: Frame identifier.
% time: Time
% x: Longitudinal direction.
% y: Lateral direction.
% team_id: Team in position of the ball.
filename = 'ball_positions_and_game_context_short.csv';
ball_positions_possessions = readtable(filename);

%% Data formatting

% starting 11's - Team_A
% row_list correspond to row in player_details table
row_list = [15,19,18,16,17,24,23,21,20,22,25];
id_start11_TeamA = players_details{row_list,1};

% starting 11's - Team_B
% row_list correspond to row in player_details table
row_list = [1,6,3,4,2,5,9,8,7,11,10];
id_start11_TeamB = players_details{row_list,1};

% pitch positions
position_list = {'GK','LB','CB1','CB2','RB','LW','CM','MF1','MF2','RW','ST'};

Team_A.x =table(); Team_A.y =table();
Team_B.x =table(); Team_B.y =table();
for i = 1:length(position_list)
    % time filtering (only first half)
    ix_time = (players_positions.frame >= game_details.kick_off_ht1 & ...
        players_positions.frame <= game_details.ht1_frame_end);
    
    % player filtering - Team_A
    ix_player = players_positions.id == id_start11_TeamA(i);
       
    Team_A.x.(position_list{i}) = ...
        players_positions.x(ix_time & ix_player);
    Team_A.y.(position_list{i}) = ...
        players_positions.y(ix_time & ix_player);
    
    % player filtering - Team_B
    ix_player = players_positions.id == id_start11_TeamB(i); 
       
    Team_B.x.(position_list{i}) = ...
        players_positions.x(ix_time & ix_player);
    Team_B.y.(position_list{i}) = ...
        players_positions.y(ix_time & ix_player);
end

% ball
ix_time = (ball_positions_possessions.frame >= game_details.kick_off_ht1 & ...
    ball_positions_possessions.frame <= game_details.ht1_frame_end);

ball = table();
ball.x = ball_positions_possessions.x(ix_time);
ball.y = ball_positions_possessions.y(ix_time);

frames = ball_positions_possessions.frame(ix_time);

% All the data is 'inverted' meaning that the corner nearer to the camera is
% the 0 (longitudinal),74.37 (lateral) point. Although irrelevant for the calculations when
% visualizing the data this was highly confusing. Therefore to better
% visualize data we inverted it. Meaning that this corner was now 0,0.
% where does 74.37 com from?
ball_y = 74.37 - ball.y;
Team_A.y{:,:} = 74.37 - Team_A.y{:,:};
Team_B.y{:,:} = 74.37 - Team_B.y{:,:};

%% Calculating velocity and speed

fs=25; % frequency sampling, Hz
dt=1/fs;

% calculating speed in x, in y, and total, as well as velocity angle
Team_A.v_x = array2table([diff(Team_A.x{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_A.v_y = array2table([diff(Team_A.y{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_A.v_total = array2table(sqrt(Team_A.v_x{:,:}.^2 + Team_A.v_y{:,:}.^2),...
    'VariableNames',position_list);
Team_A.v_angle = array2table(atan2d(Team_A.v_x{:,:},Team_A.v_y{:,:}),...
    'VariableNames',position_list);

Team_B.v_x = array2table([diff(Team_B.x{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_B.v_y = array2table([diff(Team_B.y{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_B.v_total = array2table(sqrt(Team_B.v_x{:,:}.^2 + Team_B.v_y{:,:}.^2),...
    'VariableNames',position_list);
Team_B.v_angle = array2table(atan2d(Team_B.v_x{:,:},Team_B.v_y{:,:}),...
    'VariableNames',position_list);

ball.v_x = [diff(ball.x)/dt; nan];
ball.v_y = [diff(ball.y)/dt; nan];
ball.v_total = sqrt(ball.v_x.^2 + ball.v_y.^2);
ball.v_angle = atan2d(ball.v_x,ball.v_y);

% calculating acceleration in x, in y, and total, as well as acceleration
% angle
Team_A.a_x = array2table([diff(Team_A.v_x{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_A.a_y = array2table([diff(Team_A.v_y{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_A.a_total = array2table(sqrt(Team_A.a_x{:,:}.^2 + Team_A.a_y{:,:}.^2),...
    'VariableNames',position_list);

Team_B.a_x = array2table([diff(Team_B.v_x{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_B.a_y = array2table([diff(Team_B.v_y{:,:}); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_B.a_total = array2table(sqrt(Team_B.a_x{:,:}.^2 + Team_B.a_y{:,:}.^2),...
    'VariableNames',position_list);

ball.a_x = [diff(ball.v_x); nan]/dt;
ball.a_y = [diff(ball.v_y); nan]/dt;
ball.a_total = sqrt(ball.a_x.^2 + ball.a_y.^2);

% clears unneeded data (frees up RAM)
clearvars playerspositions

%We use the data to remove the highest percentile from the velocity.
%Meaning we remove the irreal peaks related to noise. and resample the data
%once this peaks are remove.

Team_A_v_perc95 = prctile(Team_A.v_total{:,:},95);
Team_B_v_perc95 = prctile(Team_B.v_total{:,:},95);

% do the same for acceleration?
for player = 1:11
    ix_Team_A = Team_A.v_total{:,player} > Team_A_v_perc95(player);
    ix_Team_B = Team_B.v_total{:,player} > Team_B_v_perc95(player);
    
    Team_A.x{ix_Team_A,player} = nan;
    Team_A.y{ix_Team_A,player} = nan;
    Team_B.x{ix_Team_B,player} = nan;
    Team_B.y{ix_Team_B,player} = nan;
    
    Team_A.x{:,player} = resample(Team_A.x{:,player},1:size(Team_A.x));
    Team_A.y{:,player} = resample(Team_A.y{:,player},1:size(Team_A.x));

    Team_B.x{:,player} = resample(Team_B.x{:,player},1:size(Team_B.x));
    Team_B.y{:,player} = resample(Team_B.y{:,player},1:size(Team_B.x));
end

%% removing noise: smoothing timeseries using sgoaly function

%Now with clean data we use a geometrical filter and differentiate the data
%to obtain velocities. 
Team_A.x = array2table(sgolayfilt(Team_A.x{:,:},4,25),...
    'VariableNames',position_list);
Team_A.y = array2table(sgolayfilt(Team_A.y{:,:},4,25),...
    'VariableNames',position_list);

Team_B.x = array2table(sgolayfilt(Team_B.x{:,:},4,25),...
    'VariableNames',position_list);
Team_B.y = array2table(sgolayfilt(Team_B.y{:,:},4,25),...
    'VariableNames',position_list);

Team_A.v_x = array2table([sgolayfilt(diff(Team_A.x{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_A.v_y = array2table([sgolayfilt(diff(Team_A.y{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);

Team_B.v_x = array2table([sgolayfilt(diff(Team_B.x{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_B.v_y = array2table([sgolayfilt(diff(Team_B.y{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);

Team_A.v_total = array2table(sqrt(Team_A.v_x{:,:}.^2 + Team_A.v_y{:,:}.^2),...
    'VariableNames',position_list);
Team_B.v_total = array2table(sqrt(Team_B.v_x{:,:}.^2 + Team_B.v_y{:,:}.^2),...
    'VariableNames',position_list);

Team_A.a_x = array2table([sgolayfilt(diff(Team_A.v_x{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_A.a_y = array2table([sgolayfilt(diff(Team_A.v_y{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);

Team_B.a_x = array2table([sgolayfilt(diff(Team_B.v_x{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);
Team_B.a_y = array2table([sgolayfilt(diff(Team_B.v_y{:,:}),4,25); nan(1,11)]/dt,...
    'VariableNames',position_list);

Team_A.a_total = array2table(sqrt(Team_A.a_x{:,:}.^2 + Team_A.a_y{:,:}.^2),...
    'VariableNames',position_list);
Team_B.a_total = array2table(sqrt(Team_B.a_x{:,:}.^2 + Team_B.a_y{:,:}.^2),...
    'VariableNames',position_list);

% high velocity percentiles (used later on)
vt_TeamA_prct99_95 = prctile(Team_A.v_total{:,:}, 99.95);
vt_TeamB_prct99_95 = prctile(Team_B.v_total{:,:}, 99.95);

%%
% Now we intend to create two variables, one that tell us who is the team
% in posesion of the ball, and another one that tell us which is the player
% of the team that posses the ball. To do so we start by using the variable
% ball that includes a coloumn with a team code that correspond to each
% team 
ball.possession_team_id = ball_positions_possessions.team_id(ix_time);

% -1 -> 0, 554 -> 1, 475 -> 2
ball.possession_team_id(ball.possession_team_id == -1) = 0;
ball.possession_team_id(ball.possession_team_id == 554) = 1;
ball.possession_team_id(ball.possession_team_id == 475) = 2;

%Then using the identifier of the conductions we build up a ballowner
%variable that is then transform in a position (1-11) depending on which
%player posses the ball at each moment in time. 

% filtering according to event type and frames (for 1st half)
ix_pass = events.event_type_id == 1;
ix_conduct = events.event_type_id == 0;
ix_first_half = events.start_frame >= game_details.ht1_frame_start  & ...
    events.end_frame <= game_details.ht1_frame_end;

Events.pass = events(ix_pass & ix_first_half,:);
Events.conduct = events(ix_conduct & ix_first_half,:);
% clear events ?

ball.possession_player_id = nan(size(ball.possession_team_id));
for type = 1:2
    if type == 1
        event = Events.pass;
    else
        event = Events.conduct;
    end
    
    for i = 1:size(event,1)
        ix = frames >= Events.pass(i,:).start_frame & ...
            frames <= Events.pass(i,:).end_frame;
        ball.possession_player_id(ix) = event(i,:).player_id;
    end
end

% that is then transform in a position (1-11) depending on which
% player posses the ball at each moment in time. 

% creating an alternative player_id for the ball owner, correspoding to the
% column on the matrices here created.
temp = ball.possession_player_id;
ball.possession_player_id2 = nan(size(ball,1),1);

% matrix 11 x 3 (11 players per team x (ro
list = [3780 3902 1;...
    3390 3907 2;...
    3811 3904 3;...
    3781 3905 4;...
    3810 3903 5;...
    3787 3906 6;...
    3394 3910 7;...
    3838 3909 8;...
    3839 3908 9;...
    3784 3911 10;...
    3399 1428 11];

for pp = 1:11
    ix = temp == list(pp,1) | temp == list(pp,2);
    ball.possession_player_id2(ix) = list(pp,3);
end

% that is then transform in a position (1-11) depending on which
% player posses the ball at each moment in time. 

% creating an alternative player_id for the ball owner, correspoding to the
% column on the matrices here created.
temp = ball.possession_player_id;
ball.possession_player_id2 = nan(size(ball,1),1);

% matrix 11 x 3 (11 players per team + respective column number)
list = [3780 3902 1;...
    3390 3907 2;...
    3811 3904 3;...
    3781 3905 4;...
    3810 3903 5;...
    3787 3906 6;...
    3394 3910 7;...
    3838 3909 8;...
    3839 3908 9;...
    3784 3911 10;...
    3399 1428 11];

for pp = 1:11
    ix = temp == list(pp,1) | temp == list(pp,2);
    ball.possession_player_id2(ix) = list(pp,3);
end

% filters plays under study from 25 to 5 Hz to reduce noise
% subset for repository
ix_plays = [1:5:1125 2600:5:3150];

% filters "frames" array and "ball" table
frames = frames(ix_plays);
ball = ball(ix_plays,:);

% runs every field of "Team" structures
fields = fieldnames(Team_A);
for ff = 1:length(fields)
    Team_A.(fields{ff}) = Team_A.(fields{ff})(ix_plays,:);
    Team_B.(fields{ff}) = Team_B.(fields{ff})(ix_plays,:);
end

save('preprocessed_inputs.mat',...
    'Team_A','Team_B','ball',...
    'vt_TeamA_prct99_95','vt_TeamB_prct99_95')