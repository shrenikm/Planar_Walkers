%Main file that runs the compass gait simulation
clear; 
clc;

%Adding to path
addpath(genpath('Simulate/'));
addpath(genpath('Geometry/'));
addpath(genpath('Dynamics/'));

%Global parameters
global params
params.alpha = deg2rad(0.5);
params.xlim = [0, 250];
params.ylim = [0, 250];
params.right_height = 50;
params.M = 30;
params.m = 5;
params.l = 30;
params.g = 9.81;
params.fixed_x = 10;

%Simulation parameters
%Controls speed of simulation
params.sim_time_multiplier = 5;

%logical parameters
params.leg_crossed = false;
params.swing_switch = false;
params.DEBUG = false;

%Calculated parameters
params.left_height = params.right_height + (params.xlim(2) - params.xlim(1))*tan(params.alpha);
params.figure_width = params.xlim(2) - params.xlim(1);
params.figure_height = params.ylim(2) - params.ylim(1);
params.fixed_y = params.right_height + (params.figure_width - params.fixed_x)*tan(params.alpha);

%Initial parameters (Angles and velocities)
q1_init = deg2rad(-3);
q2_init = deg2rad(-20);
q1d_init = 0;
q2d_init = 0;

%Select q2 automatically for the initial position
select_q2_automatically = false;
if select_q2_automatically
    q2_init = computeQ2(q1_init);
end

%Set docked
set(0, 'DefaultFigureWindowStyle', 'docked')

%Initializing figure
[fig, ax] = initializeFigure2D('Compass-Gait', 'GridOn', params.xlim, params.ylim);

%Plotting the ground
ax = plotGround(ax);

%Plotting initial configuration
ax = plotCompass(ax, q1_init, q2_init);

%Simulating. We can simulate either after computing q2 for foot placed on
%the ground or by a manual initial value of q2. This can be selected by
%changing the boolean value selection variable above.
q_init = [q1_init; q2_init; q1d_init; q2d_init];

x_history = free_simulate(ax, q_init);

%We can plot some of the phase plots
figure(2);
plot(x_history(:, 1), x_history(:, 3));
xlabel('q1');
ylabel('q1 dot');
figure(3);
plot(x_history(:, 2), x_history(:, 4));
xlabel('q2');
ylabel('q2 dot');
















