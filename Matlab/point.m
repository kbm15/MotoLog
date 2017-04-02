function  point( x,y,t )
%POINT Summary of this function goes here
%   Detailed explanation goes here
    hold off;    
    plot(x,y,'o');
    hold on;
    plot(x(t),y(t),'ro');
    title('Mapa','FontSize',14,'FontWeight','bold')
    ylabel('Sur -> Norte')
    xlabel('Oeste -> Este')
end

