function visualize(dt, dx, L, h_array, d_W_array, d_T_array, fn, every_nth_frame)

H = 1.5; % height of the basin

h_fig = figure;
hold on ;

htext = text(0,0, '');
htext.FontWeight = 'bold';

h_basin = plot(0,0,'r', 'LineWidth', 3);
h_truck = plot(0,0,'k', 'LineWidth', 3);
h_water_surface = area(0,0, 'FaceColor', 'b');
axis equal
ylim([-0.5 -0.5+L]);

x_array = (0:dx:L)'; 

for k =1 : length(h_array)
    set(h_water_surface, 'XData', x_array + d_W_array(k), 'YData', h_array(:,k));
    set(h_basin, 'XData', [0 0 L L] + d_W_array(k), 'YData', [H 0 0 H]);
    set(h_truck, 'XData', [0 0.75 0.75 0.5 0 0] + L + d_T_array(k), 'YData', [0 0 0.5 1 1 0]);
    drawnow
    
    % Create a GIF file
    if (mod(k-1, every_nth_frame) == 0)
        write2gif(h_fig, k, fn);
        htext.Position = [d_W_array(k)+2 -0.3];
        htext.String = ['Time = ', num2str((k-1)*dt),' s'] ;
    end
end

end