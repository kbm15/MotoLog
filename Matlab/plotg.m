function  plotg( data, max_lim )
%PLOTG Summary of this function goes here
%   Detailed explanation goes here
    hold off;
    x_fake=[0 max_lim 0 -max_lim];
    
    y_fake=[max_lim 0 -max_lim 0];
    
    h_fake=compass(x_fake,y_fake);
    
    set(h_fake,'Visible','off');
    hold on;    
    compass(data);   
    title('Fuerzas G','FontSize',14,'FontWeight','bold')
end

