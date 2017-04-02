sd_data=csvread('e:/example.csv');
max_lim = 3;
figure(1)
filename = 'testnew51.gif';

for j = 1:length(sd_data)
    hold off;
    x_fake=[0 max_lim 0 -max_lim];

    y_fake=[max_lim 0 -max_lim 0];

    h_fake=compass(x_fake,y_fake);

    set(h_fake,'Visible','off');       
    hold on;
    h=compass([sd_data(j,1) sd_data(j,2)*1i]);
    pause(0.05);
    drawnow

      frame = getframe(1);

      im = frame2im(frame);

      [imind,cm] = rgb2ind(im,256);

      if j == 1;

          imwrite(imind,cm,filename,'gif', 'Loopcount',inf);

      else

          imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.05);

      end
end

