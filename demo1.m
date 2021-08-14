clear
clc
close all

L = 4;                 % the length of the water basin
dx = 0.1;              % spatial interval
N = ceil(L/dx)+1;      % divide the fluid surface into N segements

d_bar = 0.1;           % offset used in the spring force. 

d_W = [0; 0];          % initial position and velocity of the water basin
d_T = [d_bar; 0];      % initial position and velocity of the truck

c = 40e3;              % spring between the truck and water basin
k = 10e3;              % damper between the truck and water basin
g = 9.81;              % gravity constant
m_T = 2000;            % mass of the truck
m_W = 4000;            % mass of the filled basin

dt = 0.001;            % time sampling

h = zeros(N,1) + 1;    % height of the fluid column
v = zeros(N,1);        % horizontal fluid velocity 

n_it = 5000;           % how long do we run the simulation?

h_array = zeros(N,n_it);    % store h for every time step
d_W_array = zeros(1,n_it);  % store d_W for every time step
d_T_array = zeros(1,n_it);  % store d_T for every time step

for it = 1:n_it
    
    % Apply u = 2000 for 0.5 seconds
    if it < 500
        u = 4000;
    else 
        u = 0;
    end
    
    [d_W, d_T, h, v] = simulate_truck( ...
        d_W, ...
        d_T, ...
        d_bar, ...
        h, ...        
        v, ...
        u, ...
        dx, ...
        dt, ...
        L, ...
        m_W, ...
        m_T, ...
        g, ...
        k, ...
        c);
    
    % Log all data
    h_array(:,it) = h;
    d_W_array(:,it) = d_W(1);
    d_T_array(:,it) = d_T(1);
end


visualize(dt, dx, L, h_array, d_W_array, d_T_array, 'demo1.gif', 100);
