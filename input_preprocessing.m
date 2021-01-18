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
id_start11_TeamA = players_details{row_list,1};

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

%% Data parse 

%First we parse the pass events and the conductions. We only need these two
%types of events to create the teamballowner and ballowner.

p=1;
c=1;
for i=1:length(events)
    if events(i,5)==1
    Events.pass(p,:)=events(i,:);
    p=p+1;
    end
    if events(i,5)==0
       Events.conductions(c,:)=events(i,:);
       c=c+1;
    end
end

fs=25; % frequency sampling, Hz
dt=1/fs;
frame1sthalf=gamedetails(10);
frame2ndhalf=gamedetails(14);

% We build a velocity full team variable with the players parse and remove
% the irrelevant part. The one before the start of the game and in between
% the half.
vx_TeamA=[GK_TeamA(:,7) LB_TeamA(:,7) CB1_TeamA(:,7) CB2_TeamA(:,7) RB_TeamA(:,7) CM_TeamA(:,7) MF1_TeamA(:,7) MF2_TeamA(:,7) LW_TeamA(:,7) RW_TeamA(:,7) ST_TeamA(:,7) ];
vy_TeamA=[GK_TeamA(:,8) LB_TeamA(:,8) CB1_TeamA(:,8) CB2_TeamA(:,8) RB_TeamA(:,8) CM_TeamA(:,8) MF1_TeamA(:,8) MF2_TeamA(:,8) LW_TeamA(:,8) RW_TeamA(:,8) ST_TeamA(:,8) ];
vx_TeamB=[GK_TeamB(:,7) LB_TeamB(:,7) CB1_TeamB(:,7) CB2_TeamB(:,7) RB_TeamB(:,7) CM_TeamB(:,7) MF1_TeamB(:,7) MF2_TeamB(:,7)  LW_TeamB(:,7) RW_TeamB(:,7) ST_TeamB(:,7)];
vy_TeamB=[GK_TeamB(:,8) LB_TeamB(:,8) CB1_TeamB(:,8) CB2_TeamB(:,8) RB_TeamB(:,8) CM_TeamB(:,8) MF1_TeamB(:,8) MF2_TeamB(:,8) LW_TeamB(:,8)  RW_TeamB(:,8) ST_TeamB(:,8)];
vt_TeamA=[GK_TeamA(:,9) LB_TeamA(:,9) CB1_TeamA(:,9) CB2_TeamA(:,9) RB_TeamA(:,9) CM_TeamA(:,9) MF1_TeamA(:,9) MF2_TeamA(:,9) LW_TeamA(:,9) RW_TeamA(:,9) ST_TeamA(:,9) ];
vt_TeamB=[GK_TeamB(:,9) LB_TeamB(:,9) CB1_TeamB(:,9) CB2_TeamB(:,9) RB_TeamB(:,9)  CM_TeamB(:,9) MF1_TeamB(:,9) MF2_TeamB(:,9) LW_TeamB(:,9) RW_TeamB(:,9) ST_TeamB(:,9)];

ax_TeamA=[GK_TeamA(:,10) LB_TeamA(:,10) CB1_TeamA(:,10) CB2_TeamA(:,10) RB_TeamA(:,10) CM_TeamA(:,10) MF1_TeamA(:,10) MF2_TeamA(:,10) LW_TeamA(:,10) RW_TeamA(:,10) ST_TeamA(:,10) ];
ay_TeamA=[GK_TeamA(:,11) LB_TeamA(:,11) CB1_TeamA(:,11) CB2_TeamA(:,11) RB_TeamA(:,11) CM_TeamA(:,11) MF1_TeamA(:,11) MF2_TeamA(:,11) LW_TeamA(:,11)  RW_TeamA(:,11) ST_TeamA(:,11) ];
ax_TeamB=[GK_TeamB(:,10) LB_TeamB(:,10) CB1_TeamB(:,10) CB2_TeamB(:,10) RB_TeamB(:,10) CM_TeamB(:,10) MF1_TeamB(:,10) MF2_TeamB(:,10)  LW_TeamB(:,10) RW_TeamB(:,10) ST_TeamB(:,10)];
ay_TeamB=[GK_TeamB(:,11) LB_TeamB(:,11) CB1_TeamB(:,11) CB2_TeamB(:,11) RB_TeamB(:,11)  CM_TeamB(:,11) MF1_TeamB(:,11) MF2_TeamB(:,11) LW_TeamB(:,11) RW_TeamB(:,11) ST_TeamB(:,11)];
at_TeamA=[GK_TeamA(:,12) LB_TeamA(:,12) CB1_TeamA(:,12) CB2_TeamA(:,12) RB_TeamA(:,12) CM_TeamA(:,12) MF1_TeamA(:,12) MF2_TeamA(:,12) LW_TeamA(:,12)  RW_TeamA(:,12) ST_TeamA(:,12) ];
at_TeamB=[GK_TeamB(:,12) LB_TeamB(:,12) CB1_TeamB(:,12) CB2_TeamB(:,12) RB_TeamB(:,12) CM_TeamB(:,12) MF1_TeamB(:,12) MF2_TeamB(:,12)  LW_TeamB(:,12) RW_TeamB(:,12)  ST_TeamB(:,12)];

vx_TeamB_c(1:68673,1:11)=vx_TeamB(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
vx_TeamB_c(68673:143359,1:11)=vx_TeamB(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
vy_TeamB_c(1:68673,1:11)=vy_TeamB(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
vy_TeamB_c(68673:143359,1:11)=vy_TeamB(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
vt_TeamB_c(1:68673,1:11)=vt_TeamB(find(GK_TeamB(:,1)==gamedetails(10)):(find(GK_TeamB(:,1)==78985)),:);
vt_TeamB_c(68673:143359,1:11)=vt_TeamB(find(GK_TeamB(:,1)==gamedetails(14)):end,:);
vx_TeamA_c(1:68673,1:11)=vx_TeamA(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
vx_TeamA_c(68673:143359,1:11)=vx_TeamA(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
vy_TeamA_c(1:68673,1:11)=vy_TeamA(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
vy_TeamA_c(68673:143359,1:11)=vy_TeamA(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
vt_TeamA_c(1:68673,1:11)=vt_TeamA(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
vt_TeamA_c(68673:143359,1:11)=vt_TeamA(find(GK_TeamB(:,1)==gamedetails(14)):end,:);

ax_TeamB_c(1:68673,1:11)=ax_TeamB(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
ax_TeamB_c(68673:143359,1:11)=ax_TeamB(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
ay_TeamB_c(1:68673,1:11)=ay_TeamB(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
ay_TeamB_c(68673:143359,1:11)=ay_TeamB(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
at_TeamB_c(1:68673,1:11)=at_TeamB(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
at_TeamB_c(68673:143359,1:11)=at_TeamB(find(GK_TeamB(:,1)==gamedetails(14)):end,:);
ax_TeamA_c(1:68673,1:11)=ax_TeamA(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
ax_TeamA_c(68673:143359,1:11)=ax_TeamA(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
ay_TeamA_c(1:68673,1:11)=ay_TeamA(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
ay_TeamA_c(68673:143359,1:11)=ay_TeamA(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);
at_TeamA_c(1:68673,1:11)=at_TeamA(find(GK_TeamB(:,1)==gamedetails( 10)):(find(GK_TeamB(:,1)==78985)),:);
at_TeamA_c(68673:143359,1:11)=at_TeamA(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);

%We use the data to remove the highest percentile from the velocity.
%Meaning we remove the irreal peaks related to noise. and resample the data
%once this peaks are remove.

for i=1:11
    x_TeamB(find(vt_TeamB_c(:,i)>prctile(vt_TeamB_c(:,i), 95)))=nan;
    y_TeamB(find(vt_TeamB_c(:,i)>prctile(vt_TeamB_c(:,i), 95)))=nan;
    x_TeamA(find(vt_TeamA_c(:,i)>prctile(vt_TeamA_c(:,i), 95)))=nan;
    y_TeamA(find(vt_TeamA_c(:,i)>prctile(vt_TeamA_c(:,i), 95)))=nan;
end

for i=1:11
    x_TeamB(find(vt_TeamB_c(:,i)>prctile(at_TeamB_c(:,i), 95)))=nan;
    y_TeamB(find(vt_TeamB_c(:,i)>prctile(at_TeamB_c(:,i), 95)))=nan;
    x_TeamA(find(vt_TeamA_c(:,i)>prctile(at_TeamA_c(:,i), 95)))=nan;
    y_TeamA(find(vt_TeamA_c(:,i)>prctile(at_TeamA_c(:,i), 95)))=nan;
end
for i=1:11
    x_TeamB(:,i)=resample(x_TeamB(:,i),1:length(x_TeamB(:,i)));
    y_TeamB(:,i)=resample(y_TeamB(:,i),1:length(y_TeamB(:,i)));
    x_TeamA(:,i)=resample(x_TeamA(:,i),1:length(x_TeamA(:,i)));
    y_TeamA(:,i)=resample(y_TeamA(:,i),1:length(y_TeamA(:,i)));
end

%% filtrar sgoaly: dos filtros un filtro sobre la posicion, un filtro sobre la velocidad.

%Now with clean data we use a geometrical filter and differentiate the data
%to obtain velocities. 
x_TeamA=sgolayfilt(x_TeamA,4,25);
y_TeamA=sgolayfilt(y_TeamA,4,25);
x_TeamB=sgolayfilt(x_TeamB,4,25);
y_TeamB=sgolayfilt(y_TeamB,4,25);

vx_TeamA=diff(x_TeamA)/dt;
vy_TeamA=diff(y_TeamA)/dt;
vx_TeamB=diff(x_TeamB)/dt;
vy_TeamB=diff(y_TeamB)/dt;

vx_TeamA=sgolayfilt(vx_TeamA,4,25);
vy_TeamA=sgolayfilt(vy_TeamA,4,25);
vx_TeamB=sgolayfilt(vx_TeamB,4,25);
vy_TeamB=sgolayfilt(vy_TeamB,4,25);
vt_TeamA=sqrt(vx_TeamA.^2+vy_TeamA.^2);
vt_TeamB=sqrt(vx_TeamB.^2+vy_TeamB.^2);

ax_TeamA=diff(vx_TeamA)/dt;
ay_TeamA=diff(vy_TeamA)/dt;
ax_TeamB=diff(vx_TeamB)/dt;
ay_TeamB=diff(vy_TeamB)/dt;

ax_TeamA=sgolayfilt(ax_TeamA,4,25);
ay_TeamA=sgolayfilt(ay_TeamA,4,25);
ax_TeamB=sgolayfilt(ax_TeamB,4,25);
ay_TeamB=sgolayfilt(ay_TeamB,4,25);

at_TeamA=sqrt(ax_TeamA.^2+ay_TeamA.^2);
at_TeamB=sqrt(ax_TeamB.^2+ay_TeamB.^2);

% high velocity percentiles (used later on)
vt_TeamA_prct99_95 = prctile(vt_TeamA, 99.95);
vt_TeamB_prct99_95 = prctile(vt_TeamB, 99.95);

%%
% Now we intend to create two variables, one that tell us who is the team
% in posesion of the ball, and another one that tell us which is the player
% of the team that posses the ball. To do so we start by using the variable
% ball that includes a coloumn with a team code that correspond to each
% team 
teamballowner(1:length(ball))=0;
ballowner(1:length(ball))=0;
for i=1:length(ball)
   if ball(i,5)==554
       teamballowner(i)=1;
   end
   if ball(i,5)==475
       teamballowner(i)=2;
   end       
end

%Then using the identifier of the conductions we build up a ballowner
%variable that is then transform in a position (1-11) depending on which
%player posses the ball at each moment in time. 
for i=1:length(Events.conductions)
    if Events.conductions(i,8)<gamedetails(9)
        ballowner((Events.conductions(i,8):Events.conductions(i,9))-gamedetails(10))= Events.conductions(i,6) ;   
    end
    if Events.conductions(i,8)>=gamedetails(9)
        ballowner(((Events.conductions(i,8):Events.conductions(i,9))-gamedetails( 14))+68673)= Events.conductions(i,6) ;   
    end
end

for i=1:length(ballowner)
    if ballowner(i)==playersdetails(1,1) || ballowner(i)==playersdetails(15,1)
        ballowner(i)=1;
    end
    if ballowner(i)==playersdetails(19,1)|| ballowner(i)==playersdetails(6,1)
        ballowner(i)=2;
    end
     if ballowner(i)==playersdetails(3,1) || ballowner(i)==playersdetails(18,1) || ballowner(i)==playersdetails(14,1)
        ballowner(i)=3;
     end
     if ballowner(i)==playersdetails(16,1)|| ballowner(i)==playersdetails(4,1) 
        ballowner(i)=4;
     end
      if ballowner(i)==playersdetails(2,1) || ballowner(i)==playersdetails(17,1)
        ballowner(i)=5;
      end
      if ballowner(i)==playersdetails(9,1) || ballowner(i)==playersdetails(23,1) || ballowner(i)==playersdetails(27,1) || (ballowner(i)==playersdetails(21,1) && i>=88859)
        ballowner(i)=6;
      end
      if ballowner(i)==playersdetails(8,1) || (ballowner(i)==playersdetails(21,1) && i<88859) || (ballowner(i)==playersdetails(22,1) && i>=88859)
        ballowner(i)=7;
      end
      if (ballowner(i)==playersdetails(7,1) && i<108830) || ballowner(i)==playersdetails(13,1) || ballowner(i)==playersdetails(20,1)
        ballowner(i)=8;
      end
      if ballowner(i)==playersdetails(24,1) || (ballowner(i)==playersdetails(7,1) && i>=108830)|| ballowner(i)==playersdetails(5,1) 
        ballowner(i)=9;
      end
      if ballowner(i)==playersdetails(11,1) || ballowner(i)==playersdetails(12,1) || ballowner(i)==playersdetails(22,1)  || ballowner(i)==playersdetails(28,1) || (ballowner(i)==playersdetails(25,1) && i>=88859) 
        ballowner(i)=10;
      end
      if ballowner(i)==playersdetails(10,1) || (ballowner(i)==playersdetails(25,1) && i<88859) ||ballowner(i)==playersdetails(26,1)
        ballowner(i)=11;
      end
end

% filters plays under study from 25 to 5 Hz to reduce noise
ix = [1:5:1125 2600:5:3150];
x_TeamA = x_TeamA(ix,:);
y_TeamA = y_TeamA(ix,:);

x_TeamB = x_TeamB(ix,:);
y_TeamB = y_TeamB(ix,:);

vx_TeamA = vx_TeamA(ix,:);
vy_TeamA = vy_TeamA(ix,:);
vt_TeamA = vt_TeamA(ix,:);

vx_TeamB = vx_TeamB(ix,:);
vy_TeamB = vy_TeamB(ix,:);
vt_TeamB = vt_TeamB(ix,:);

ax_TeamA = ax_TeamA(ix,:);
ay_TeamA = ay_TeamA(ix,:);
at_TeamA = at_TeamA(ix,:);

ax_TeamB = ax_TeamB(ix,:);
ay_TeamB = ay_TeamB(ix,:);
at_TeamB = at_TeamB(ix,:);

teamballowner = teamballowner(ix);
ballowner = ballowner(ix);

save('preprocessed_inputs.mat',...
    'teamballowner','ballowner',...
    'x_TeamA','y_TeamA','x_TeamB','y_TeamB',...
    'vx_TeamA','vy_TeamA','vt_TeamA','vx_TeamB','vy_TeamB','vt_TeamB',...
    'ax_TeamA','ay_TeamA','at_TeamA','ax_TeamB','ay_TeamB','at_TeamB',...
    'vt_TeamA_prct99_95','vt_TeamB_prct99_95')