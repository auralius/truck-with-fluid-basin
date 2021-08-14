% v_t = fluid_vertical_acceelration at time t at position x
% a_W = average acceleration of the basin owing to fluid motion
% see Eq. 3

function a_W = calculate_a_W(v_t, dx, L)

N = length(v_t);
a_W = 0;

for k = 1:N-1
    a_W = a_W + v_t(k) * dx;
end

a_W = a_W / L;
end