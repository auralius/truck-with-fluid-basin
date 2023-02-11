%% Mathematical model of a truck with a water basin
%
% References:
%   Numerical optimal control of a coupled ODE-PDE model of a truck with a
%   fluid basin
%   http://www.aimsciences.org/article/doi/10.3934/proc.2015.0515
%
% d_W is a 2x1 vector which contains the position and speed of the water
% basin
%
% d_T is a 2x1 vector which contains the position and speed of the moving
% truck

%%
function [d_W, d_T, h, v] = simulate_truck( ...
    d_W, ...     % initial position and velocity of the water basin (2 x 1 vector) 
    d_T, ...     % initial position and velocity of the truck (2 x 1 vector)
    d_bar, ...   % offset used in the spring force. 
    h, ...       % height of the fluid column (N x 1 vector)
    v, ...       % horizontal fluid velocity (N x 1 vector)
    u, ...       % input force to the truck
    dx, ...      % spatial interval
    dt, ...      % time sampling
    L, ...       % the length of the water basin
    m_W, ...     % mass of the filled basin
    m_T, ...     % mass of the truck
    g, ...       % gravity constant
    k, ...       % damper between the truck and water basin
    c)           % spring between the truck and water basin

N = length(h);

v_t = zeros(1, N);
h_next = zeros(1, N);
v_next = zeros(1, N);

% Force between the truck and the filled basin
F = c*(d_T(1)-d_W(1)-d_bar) + k*(d_T(2)-d_W(2));

% Update the fluid column height
for j = 2 : N - 1
    h_next(j) = -dt/(2*dx) * (h(j+1)*v(j+1)-h(j-1)*v(j-1)) + 0.5 * (h(j+1)+h(j-1));
end

% Update the fluid horizontal velocit
for j = 2 : N - 1
    v_next(j) = -dt/m_W * F - dt/(2*dx) * ( 0.5*v(j+1)^2 + g*h(j++1) - 0.5*v(j-1)^2 - g*h(j-1)) + 0.5*( v(j+1)+v(j-1) );
end

h = h_next;
v = v_next;

% Apply BCs
h(1) = h(2) + dx/(g*m_W)*F;
h(end) = h(end-1) - dx/(g*m_W)*F;


% Horizontal acceleration of the fluid insde the basin
for j = 2 : N - 1
    v_t(j) = 1/dt * (v_next(j) - 0.5*(v(j-1)+v(j+1))  );
end

% Average of the horizontal acceleration contributes to the movement of the
% water basin
a_W = calculate_a_W(v_t, dx, L);

% Forward Euler integration 
d_T_ddot = (u - F ) / m_T;
d_T(2) = d_T(2) + d_T_ddot*dt;
d_T(1) = d_T(1) + d_T(2)*dt;

d_W_ddot = (F  + m_W*a_W) / m_W;
d_W(2) = d_W(2) + d_W_ddot*dt;
d_W(1) = d_W(1) + d_W(2)*dt;

end


