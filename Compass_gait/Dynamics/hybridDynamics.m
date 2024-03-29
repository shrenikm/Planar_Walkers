%Hybrid Dynamics for the compass gait, including all gate switching and
%transition velocities

%INPUT: State vector
%OUTPUT: Updated state vector with the new post impact configurations and
%velocities

function x = hybridDynamics(x)

global params

pos_struct = {};
pos_struct.above = 1;
pos_struct.on = 0;
pos_struct.below = -1;

%Checking if the swing toe is touching or below the ground
out = getFeetPosGround(x(1), x(2));

%For simulation, the impact is triggered when the swing toe touches the
%ground, the swing leg is beyond the stance leg and the swing leg velocity
%has switched signs (After max oscillation)
if out == pos_struct.below && params.leg_crossed && params.swing_switch
    
    q1 = x(1);
    q2 = x(2);
    q1d = x(3);
    q2d = x(4);
    
    if params.DEBUG
        fprintf('Impact!\n');
    end
    
    %Compute new velocities
    M = computeImpactM(x(1:2));
   
    %C matrix that contains the basis of the null space 
    C = [1 0 -params.l*cos(q1) params.l*cos(q2); 0 1 -params.l*sin(q1) params.l*sin(q2)].';
    
    %Augmenting the generalized velocities to incorporate the two extra
    %velocities
    qd_pre = [0; 0; x(3:4)];
    impulse_mat = eye(4, 4) - inv(M)*C*inv(C.'*inv(M)*C)*C.';
    qd_pos = impulse_mat*qd_pre;
    
    x(3:4) = qd_pos(3:4);
    
    %Changing position of fixed leg in the simulation
    [~, ~, ~, ~, ~, ~, swing_x, swing_y] = computePos(x(1), x(2));
    
    %Position of the fixed leg is now the position of the swing leg
    params.fixed_x = swing_x;
    params.fixed_y = swing_y;
    
    
    %Switching positions and velocities
    x([1, 2]) = x([2, 1]);
    x([3, 4]) = x([4, 3]);
    
    %Resetting flags
    params.leg_crossed = false;
    params.swing_switched = false;
     
    
end
