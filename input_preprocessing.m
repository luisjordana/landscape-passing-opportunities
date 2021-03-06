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
filename = 'teams_details.csv';
teamsdetails = importteamsdetails(filename);

filename = 'events.csv';
events = importevents(filename);

filename = 'players_positions_short.csv';
playerspositions = importplayerspositions(filename);

filename = 'players_details.csv';
playersdetails = importplayersdetails(filename);

filename = 'game_details.csv';
gamedetails = importgamedetails(filename);

filename = 'ball_positions_and_game_context_short.csv';
% filename = 'ball_positions_and_game_context_short.csv';
ballpositionsandgamecontext = importball(filename);

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

% Using the information available in playerdetails we parse players
% position into the 11 players each team has. 
GK_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(15,1)),:);
RB_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(17,1)),:);
LB_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(19,1)),:);
CB1_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(18,1)),:);
CB2_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(16,1)),:);
MF1_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(21,1)),:);
LW_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(24,1)),:);
CM_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(23,1)),:);
MF2_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(20,1)),:);
ST_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(25,1)),:);
RW_TeamA=playerspositions(find(playerspositions(:,3)==playersdetails(22,1)),:);

GK_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(1,1)),:);
LB_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(6,1)),:);
CB1_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(3,1)),:);
CB2_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(4,1)),:);
RB_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(2,1)),:);
LW_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(5,1)),:);
CM_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(9,1)),:);
MF1_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(8,1)),:);
MF2_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(7,1)),:);
RW_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(11,1)),:);
ST_TeamB=playerspositions(find(playerspositions(:,3)==playersdetails(10,1)),:);

fs=25; % frequency sampling, Hz
dt=1/fs;
frame1sthalf=gamedetails(10);
frame2ndhalf=gamedetails(14);

% velocity, x-axis, Team_A
GK_TeamA(1:end-1,7)= diff(GK_TeamA(:,4))/dt;
RB_TeamA(1:end-1,7)=diff(RB_TeamA(:,4))/dt;
CB1_TeamA(1:end-1,7)=diff(CB1_TeamA(:,4))/dt;
CB2_TeamA(1:end-1,7)=diff(CB2_TeamA(:,4))/dt;
LB_TeamA(1:end-1,7)=diff(LB_TeamA(:,4))/dt;
CM_TeamA(1:end-1,7)=diff(CM_TeamA(:,4))/dt;
MF1_TeamA(1:end-1,7)=diff(MF1_TeamA(:,4))/dt;
MF2_TeamA(1:end-1,7)=diff(MF2_TeamA(:,4))/dt;
LW_TeamA(1:end-1,7)=diff(LW_TeamA(:,4))/dt;
ST_TeamA(1:end-1,7)=diff(ST_TeamA(:,4))/dt;
RW_TeamA(1:end-1,7)=diff(RW_TeamA(:,4))/dt;

% velocity, y-axis, Team_A
GK_TeamA(1:end-1,8)= diff(GK_TeamA(:,5))/dt;
RB_TeamA(1:end-1,8)=diff(RB_TeamA(:,5))/dt;
CB1_TeamA(1:end-1,8)=diff(CB1_TeamA(:,5))/dt;
CB2_TeamA(1:end-1,8)=diff(CB2_TeamA(:,5))/dt;
LB_TeamA(1:end-1,8)=diff(LB_TeamA(:,5))/dt;
CM_TeamA(1:end-1,8)=diff(CM_TeamA(:,5))/dt;
MF1_TeamA(1:end-1,8)=diff(MF1_TeamA(:,5))/dt;
MF2_TeamA(1:end-1,8)=diff(MF2_TeamA(:,5))/dt;
LW_TeamA(1:end-1,8)=diff(LW_TeamA(:,5))/dt;
ST_TeamA(1:end-1,8)=diff(ST_TeamA(:,5))/dt;
RW_TeamA(1:end-1,8)=diff(RW_TeamA(:,5))/dt;

% velocity, absolute value, Team_A
GK_TeamA(:,9)= sqrt( GK_TeamA(:,7).^2+GK_TeamA(:,8).^2);
RB_TeamA(:,9)=sqrt( RB_TeamA(:,7).^2+RB_TeamA(:,8).^2);
CB1_TeamA(:,9)=sqrt( CB1_TeamA(:,7).^2+CB1_TeamA(:,8).^2);
CB2_TeamA(:,9)=sqrt( CB2_TeamA(:,7).^2+CB2_TeamA(:,8).^2);
LB_TeamA(:,9)=sqrt( LB_TeamA(:,7).^2+LB_TeamA(:,8).^2);
CM_TeamA(:,9)=sqrt( CM_TeamA(:,7).^2+CM_TeamA(:,8).^2);
MF1_TeamA(:,9)=sqrt( MF1_TeamA(:,7).^2+MF1_TeamA(:,8).^2);
MF2_TeamA(:,9)=sqrt( MF2_TeamA(:,7).^2+MF2_TeamA(:,8).^2);
LW_TeamA(:,9)=sqrt( LW_TeamA(:,7).^2+LW_TeamA(:,8).^2);
ST_TeamA(:,9)=sqrt( ST_TeamA(:,7).^2+ST_TeamA(:,8).^2);
RW_TeamA(:,9)=sqrt( RW_TeamA(:,7).^2+RW_TeamA(:,8).^2);

% acceleration, x-axis, Team_A
GK_TeamA(1:end-1,10)= diff(GK_TeamA(:,7))/dt;
RB_TeamA(1:end-1,10)=diff(RB_TeamA(:,7))/dt;
CB1_TeamA(1:end-1,10)=diff(CB1_TeamA(:,7))/dt;
CB2_TeamA(1:end-1,10)=diff(CB2_TeamA(:,7))/dt;
LB_TeamA(1:end-1,10)=diff(LB_TeamA(:,7))/dt;
CM_TeamA(1:end-1,10)=diff(CM_TeamA(:,7))/dt;
MF1_TeamA(1:end-1,10)=diff(MF1_TeamA(:,7))/dt;
MF2_TeamA(1:end-1,10)=diff(MF2_TeamA(:,7))/dt;
LW_TeamA(1:end-1,10)=diff(LW_TeamA(:,7))/dt;
ST_TeamA(1:end-1,10)=diff(ST_TeamA(:,7))/dt;
RW_TeamA(1:end-1,10)=diff(RW_TeamA(:,7))/dt;

% acceleration, y-axis, Team_A
GK_TeamA(1:end-1,11)= diff(GK_TeamA(:,8))/dt;
RB_TeamA(1:end-1,11)=diff(RB_TeamA(:,8))/dt;
CB1_TeamA(1:end-1,11)=diff(CB1_TeamA(:,8))/dt;
CB2_TeamA(1:end-1,11)=diff(CB2_TeamA(:,8))/dt;
LB_TeamA(1:end-1,11)=diff(LB_TeamA(:,8))/dt;
CM_TeamA(1:end-1,11)=diff(CM_TeamA(:,8))/dt;
MF1_TeamA(1:end-1,11)=diff(MF1_TeamA(:,8))/dt;
MF2_TeamA(1:end-1,11)=diff(MF2_TeamA(:,8))/dt;
LW_TeamA(1:end-1,11)=diff(LW_TeamA(:,8))/dt;
ST_TeamA(1:end-1,11)=diff(ST_TeamA(:,8))/dt;
RW_TeamA(1:end-1,11)=diff(RW_TeamA(:,8))/dt;

% acceleration, absolute value, Team_A
GK_TeamA(:,12)= sqrt( GK_TeamA(:,10).^2+GK_TeamA(:,11).^2);
RB_TeamA(:,12)=sqrt( RB_TeamA(:,10).^2+RB_TeamA(:,11).^2);
CB1_TeamA(:,12)=sqrt( CB1_TeamA(:,10).^2+CB1_TeamA(:,11).^2);
CB2_TeamA(:,12)=sqrt( CB2_TeamA(:,10).^2+CB2_TeamA(:,11).^2);
LB_TeamA(:,12)=sqrt( LB_TeamA(:,10).^2+LB_TeamA(:,11).^2);
CM_TeamA(:,12)=sqrt( CM_TeamA(:,10).^2+CM_TeamA(:,11).^2);
MF1_TeamA(:,12)=sqrt( MF1_TeamA(:,10).^2+MF1_TeamA(:,11).^2);
MF2_TeamA(:,12)=sqrt( MF2_TeamA(:,10).^2+MF2_TeamA(:,11).^2);
LW_TeamA(:,12)=sqrt( LW_TeamA(:,10).^2+LW_TeamA(:,11).^2);
ST_TeamA(:,12)=sqrt( ST_TeamA(:,10).^2+ST_TeamA(:,11).^2);
RW_TeamA(:,12)=sqrt( RW_TeamA(:,10).^2+RW_TeamA(:,11).^2);

% velocity, x-axis, Team_B
GK_TeamB(1:end-1,7)= diff(GK_TeamB(:,4))/dt;
RB_TeamB(1:end-1,7)=diff(RB_TeamB(:,4))/dt;
CB1_TeamB(1:end-1,7)=diff(CB1_TeamB(:,4))/dt;
CB2_TeamB(1:end-1,7)=diff(CB2_TeamB(:,4))/dt;
LB_TeamB(1:end-1,7)=diff(LB_TeamB(:,4))/dt;
LW_TeamB(1:end-1,7)=diff(LW_TeamB(:,4))/dt;
CM_TeamB(1:end-1,7)=diff(CM_TeamB(:,4))/dt;
MF1_TeamB(1:end-1,7)=diff(MF1_TeamB(:,4))/dt;
MF2_TeamB(1:end-1,7)=diff(MF2_TeamB(:,4))/dt;
RW_TeamB(1:end-1,7)=diff(RW_TeamB(:,4))/dt;
ST_TeamB(1:end-1,7)=diff(ST_TeamB(:,4))/dt;

% velocity, y-axis, Team_B
GK_TeamB(1:end-1,8)= diff(GK_TeamB(:,5))/dt;
RB_TeamB(1:end-1,8)=diff(RB_TeamB(:,5))/dt;
CB1_TeamB(1:end-1,8)=diff(CB1_TeamB(:,5))/dt;
CB2_TeamB(1:end-1,8)=diff(CB2_TeamB(:,5))/dt;
LB_TeamB(1:end-1,8)=diff(LB_TeamB(:,5))/dt;
LW_TeamB(1:end-1,8)=diff(LW_TeamB(:,5))/dt;
CM_TeamB(1:end-1,8)=diff(CM_TeamB(:,5))/dt;
MF1_TeamB(1:end-1,8)=diff(MF1_TeamB(:,5))/dt;
MF2_TeamB(1:end-1,8)=diff(MF2_TeamB(:,5))/dt;
RW_TeamB(1:end-1,8)=diff(RW_TeamB(:,5))/dt;
ST_TeamB(1:end-1,8)=diff(ST_TeamB(:,5))/dt;

% velocity, absolute value, Team_B
GK_TeamB(:,9)= sqrt( GK_TeamB(:,7).^2+GK_TeamB(:,8).^2);
RB_TeamB(:,9)=sqrt( RB_TeamB(:,7).^2+RB_TeamB(:,8).^2);
CB1_TeamB(:,9)=sqrt( CB1_TeamB(:,7).^2+CB1_TeamB(:,8).^2);
CB2_TeamB(:,9)=sqrt( CB2_TeamB(:,7).^2+CB2_TeamB(:,8).^2);
LB_TeamB(:,9)=sqrt( LB_TeamB(:,7).^2+LB_TeamB(:,8).^2);
LW_TeamB(:,9)=sqrt( LW_TeamB(:,7).^2+LW_TeamB(:,8).^2);
CM_TeamB(:,9)=sqrt( CM_TeamB(:,7).^2+CM_TeamB(:,8).^2);
MF1_TeamB(:,9)=sqrt( MF1_TeamB(:,7).^2+MF1_TeamB(:,8).^2);
MF2_TeamB(:,9)=sqrt( MF2_TeamB(:,7).^2+MF2_TeamB(:,8).^2);
RW_TeamB(:,9)=sqrt( RW_TeamB(:,7).^2+RW_TeamB(:,8).^2);
ST_TeamB(:,9)=sqrt( ST_TeamB(:,7).^2+ST_TeamB(:,8).^2);

% acceleration, x-axis, Team_B
GK_TeamB(1:end-1,10)= diff(GK_TeamB(:,7))/dt;
RB_TeamB(1:end-1,10)=diff(RB_TeamB(:,7))/dt;
CB1_TeamB(1:end-1,10)=diff(CB1_TeamB(:,7))/dt;
CB2_TeamB(1:end-1,10)=diff(CB2_TeamB(:,7))/dt;
LB_TeamB(1:end-1,10)=diff(LB_TeamB(:,7))/dt;
LW_TeamB(1:end-1,10)=diff(LW_TeamB(:,7))/dt;
CM_TeamB(1:end-1,10)=diff(CM_TeamB(:,7))/dt;
MF1_TeamB(1:end-1,10)=diff(MF1_TeamB(:,7))/dt;
MF2_TeamB(1:end-1,10)=diff(MF2_TeamB(:,7))/dt;
RW_TeamB(1:end-1,10)=diff(RW_TeamB(:,7))/dt;
ST_TeamB(1:end-1,10)=diff(ST_TeamB(:,7))/dt;

% acceleration, y-axis, Team_B
GK_TeamB(1:end-1,11)= diff(GK_TeamB(:,8))/dt;
RB_TeamB(1:end-1,11)=diff(RB_TeamB(:,8))/dt;
CB1_TeamB(1:end-1,11)=diff(CB1_TeamB(:,8))/dt;
CB2_TeamB(1:end-1,11)=diff(CB2_TeamB(:,8))/dt;
LB_TeamB(1:end-1,11)=diff(LB_TeamB(:,8))/dt;
LW_TeamB(1:end-1,11)=diff(LW_TeamB(:,8))/dt;
CM_TeamB(1:end-1,11)=diff(CM_TeamB(:,8))/dt;
MF1_TeamB(1:end-1,11)=diff(MF1_TeamB(:,8))/dt;
MF2_TeamB(1:end-1,11)=diff(MF2_TeamB(:,8))/dt;
RW_TeamB(1:end-1,11)=diff(RW_TeamB(:,8))/dt;
ST_TeamB(1:end-1,11)=diff(ST_TeamB(:,8))/dt;

% acceleration, absolute value, Team_B
GK_TeamB(:,12)= sqrt( GK_TeamB(:,10).^2+GK_TeamB(:,11).^2);
RB_TeamB(:,12)=sqrt( RB_TeamB(:,10).^2+RB_TeamB(:,11).^2);
CB1_TeamB(:,12)=sqrt( CB1_TeamB(:,10).^2+CB1_TeamB(:,11).^2);
CB2_TeamB(:,12)=sqrt( CB2_TeamB(:,10).^2+CB2_TeamB(:,11).^2);
LB_TeamB(:,12)=sqrt( LB_TeamB(:,10).^2+LB_TeamB(:,11).^2);
LW_TeamB(:,12)=sqrt( LW_TeamB(:,10).^2+LW_TeamB(:,11).^2);
CM_TeamB(:,12)=sqrt( CM_TeamB(:,10).^2+CM_TeamB(:,11).^2);
MF1_TeamB(:,12)=sqrt( MF1_TeamB(:,10).^2+MF1_TeamB(:,11).^2);
MF2_TeamB(:,12)=sqrt( MF2_TeamB(:,10).^2+MF2_TeamB(:,11).^2);
RW_TeamB(:,12)=sqrt( RW_TeamB(:,10).^2+RW_TeamB(:,11).^2);
ST_TeamB(:,12)=sqrt( ST_TeamB(:,10).^2+ST_TeamB(:,11).^2);

clearvars playerspositions

%% First cut 
%Using the information avaialable in Gamedetails we eliminate the
%information before the game started and in between halfs. 

% Team_A
GK_TeamA_c=GK_TeamA(find(GK_TeamA(:,1)==gamedetails( 10)):(find(GK_TeamA(:,1)==78985)),:);
GK_TeamA_c(68673:143359,:)=GK_TeamA(find(GK_TeamA(:,1)==gamedetails( 14)):end,:);
LB_TeamA_c=LB_TeamA(find(LB_TeamA(:,1)==gamedetails( 10)):(find(LB_TeamA(:,1)==78985)),:);
LB_TeamA_c(68673:143359,:)=LB_TeamA(find(LB_TeamA(:,1)==gamedetails( 14)):end,:);
RB_TeamA_c=RB_TeamA(find(RB_TeamA(:,1)==gamedetails( 10)):(find(RB_TeamA(:,1)==78985)),:);
RB_TeamA_c(68673:143359,:)=RB_TeamA(find(RB_TeamA(:,1)==gamedetails( 14)):end,:);
CB1_TeamA_c=CB1_TeamA(find(CB1_TeamA(:,1)==gamedetails( 10)):(find(CB1_TeamA(:,1)==78985)),:);
CB1_TeamA_c(68673:143359,:)=CB1_TeamA(find(CB1_TeamA(:,1)==gamedetails( 14)):end,:);
CB2_TeamA_c=CB2_TeamA(find(CB2_TeamA(:,1)==gamedetails(10)):(find(CB2_TeamA(:,1)==78985)),:);
CB2_TeamA_c(68673:143359,:)=CB2_TeamA(find(CB2_TeamA(:,1)==gamedetails( 14)):end,:);
CM_TeamA_c=CM_TeamA(find(CM_TeamA(:,1)==gamedetails(10)):(find(CM_TeamA(:,1)==78985)),:);
CM_TeamA_c(68673:143359,:)=CM_TeamA(find(CM_TeamA(:,1)==gamedetails(14)):end,:);
MF1_TeamA_c=MF1_TeamA(find(MF1_TeamA(:,1)==gamedetails( 10)):(find(MF1_TeamA(:,1)==78985)),:);
MF1_TeamA_c(68673:143359,:)=MF1_TeamA(find(MF1_TeamA(:,1)==gamedetails( 14)):end,:);
MF2_TeamA_c=MF2_TeamA(find(MF2_TeamA(:,1)==gamedetails( 10)):(find(MF2_TeamA(:,1)==78985)),:);
MF2_TeamA_c(68673:143359,:)=MF2_TeamA(find(MF2_TeamA(:,1)==gamedetails(14)):end,:);
LW_TeamA_c=LW_TeamA(find(LW_TeamA(:,1)==gamedetails( 10)):(find(LW_TeamA(:,1)==78985)),:);
LW_TeamA_c(68673:143359,:)=LW_TeamA(find(LW_TeamA(:,1)==gamedetails( 14)):end,:);
ST_TeamA_c=ST_TeamA(find(ST_TeamA(:,1)==gamedetails( 10)):(find(ST_TeamA(:,1)==78985)),:);
ST_TeamA_c(68673:143359,:)=ST_TeamA(find(ST_TeamA(:,1)==gamedetails( 14)):end,:);
RW_TeamA_c=RW_TeamA(find(RW_TeamA(:,1)==gamedetails( 10)):(find(RW_TeamA(:,1)==78985)),:);
RW_TeamA_c(68673:143359,:)=RW_TeamA(find(RW_TeamA(:,1)==gamedetails(14)):end,:);

% Team_B
GK_TeamB_c=GK_TeamB(find(GK_TeamB(:,1)==gamedetails(10)):(find(GK_TeamB(:,1)==78985)),:);
GK_TeamB_c(68673:143359,:)=GK_TeamB(find(GK_TeamB(:,1)==gamedetails( 14)):end,:);

LB_TeamB_c=LB_TeamB(find(LB_TeamB(:,1)==gamedetails(10)):(find(LB_TeamB(:,1)==78985)),:);
LB_TeamB_c(68673:143359,:)=LB_TeamB(find(LB_TeamB(:,1)==gamedetails(14)):end,:);

RB_TeamB_c=RB_TeamB(find(RB_TeamB(:,1)==gamedetails( 10)):(find(RB_TeamB(:,1)==78985)),:);
RB_TeamB_c(68673:143359,:)=RB_TeamB(find(RB_TeamB(:,1)==gamedetails(14)):end,:);

CB1_TeamB_c=CB1_TeamB(find(CB1_TeamB(:,1)==gamedetails( 10)):(find(CB1_TeamB(:,1)==78985)),:);
CB1_TeamB_c(68673:143359,:)=CB1_TeamB(find(CB1_TeamB(:,1)==gamedetails( 14)):end,:);

CB2_TeamB_c=CB2_TeamB(find(CB2_TeamB(:,1)==gamedetails(10)):(find(CB2_TeamB(:,1)==78985)),:);
CB2_TeamB_c(68673:143359,:)=CB2_TeamB(find(CB2_TeamB(:,1)==gamedetails( 14)):end,:);

CM_TeamB_c=CM_TeamB(find(CM_TeamB(:,1)==gamedetails( 10)):(find(CM_TeamB(:,1)==78985)),:);
CM_TeamB_c(68673:143359,:)=CM_TeamB(find(CM_TeamB(:,1)==gamedetails(14)):end,:);

MF1_TeamB_c=MF1_TeamB(find(MF1_TeamB(:,1)==gamedetails(10)):(find(MF1_TeamB(:,1)==78985)),:);
MF1_TeamB_c(68673:143359,:)=MF1_TeamB(find(MF1_TeamB(:,1)==gamedetails(14)):end,:);

LW_TeamB_c=LW_TeamB(find(LW_TeamB(:,1)==gamedetails( 10)):(find(LW_TeamB(:,1)==78985)),:);
LW_TeamB_c(68673:143359,:)=LW_TeamB(find(LW_TeamB(:,1)==gamedetails(14)):end,:);

MF2_TeamB_c=MF2_TeamB(find(MF2_TeamB(:,1)==gamedetails( 10)):(find(MF2_TeamB(:,1)==78985)),:);
MF2_TeamB_c(68673:143359,:)=MF2_TeamB(find(MF2_TeamB(:,1)==gamedetails( 14)):end,:);

RW_TeamB_c=RW_TeamB(find(RW_TeamB(:,1)==gamedetails( 10)):(find(RW_TeamB(:,1)==78985)),:);
RW_TeamB_c(68673:143359,:)=RW_TeamB(find(RW_TeamB(:,1)==gamedetails( 14)):end,:);

ST_TeamB_c=ST_TeamB(find(ST_TeamB(:,1)==gamedetails( 10)):(find(ST_TeamB(:,1)==78985)),:);
ST_TeamB_c(68673:143359,:)=ST_TeamB(find(ST_TeamB(:,1)==gamedetails( 14)):end,:);

% We do the same for the ball.
ball=ballpositionsandgamecontext(find(ballpositionsandgamecontext(:,1)==gamedetails( 10)):(find(ballpositionsandgamecontext(:,1)==78985)),:);
ball(68673:143360,:)=ballpositionsandgamecontext(find(ballpositionsandgamecontext(:,1)==gamedetails( 14)):end,:);
time=(1:length(ST_TeamA_c))*dt;

%All the data is 'inverted' meaning that the corner nearer to the camera is
% the 0 (longitudinal),74.37 (lateral) point. Although irrelevant for the calculations when
% visualizing the data this was highly confusing. Therefore to better
% visualize data we inverted it. Meaning that this corner was now 0,0.
xball=ball(:,3);
yball=74.37-ball(:,4);
x_TeamB=[GK_TeamB_c(:,4) LB_TeamB_c(:,4) CB1_TeamB_c(:,4) CB2_TeamB_c(:,4) RB_TeamB_c(:,4)  CM_TeamB_c(:,4) MF1_TeamB_c(:,4) MF2_TeamB_c(:,4) LW_TeamB_c(:,4) RW_TeamB_c(:,4) ST_TeamB_c(:,4)];
y_TeamB=74.37-[GK_TeamB_c(:,5) LB_TeamB_c(:,5) CB1_TeamB_c(:,5) CB2_TeamB_c(:,5) RB_TeamB_c(:,5)  CM_TeamB_c(:,5) MF1_TeamB_c(:,5) MF2_TeamB_c(:,5) LW_TeamB_c(:,5) RW_TeamB_c(:,5) ST_TeamB_c(:,5)];
x_TeamA=[GK_TeamA_c(:,4) LB_TeamA_c(:,4) CB1_TeamA_c(:,4) CB2_TeamA_c(:,4) RB_TeamA_c(:,4)  CM_TeamA_c(:,4) MF1_TeamA_c(:,4) MF2_TeamA_c(:,4)   LW_TeamA_c(:,4) RW_TeamA_c(:,4) ST_TeamA_c(:,4) ];
y_TeamA=74.37-[GK_TeamA_c(:,5) LB_TeamA_c(:,5) CB1_TeamA_c(:,5) CB2_TeamA_c(:,5) RB_TeamA_c(:,5)  CM_TeamA_c(:,5) MF1_TeamA_c(:,5) MF2_TeamA_c(:,5) LW_TeamA_c(:,5) RW_TeamA_c(:,5) ST_TeamA_c(:,5)  ];

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