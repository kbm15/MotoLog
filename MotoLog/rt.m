clear
a = arduino('/dev/ttyS101','Mega2560');
interv = 1000;
passo = 1;
t=1;
x=0;            
max_lim = 1;
while(t<interv)
    b=analogThis(readVoltage(a, 'A0'))+analogThis(readVoltage(a, 'A1'))*1i;
    subplot(211)
    hold off;
    x_fake=[0 max_lim 0 -max_lim];
    
    y_fake=[max_lim 0 -max_lim 0];
    
    h_fake=compass(x_fake,y_fake);
    
    set(h_fake,'Visible','off');
    hold on;    
    h=compass(b);    
    subplot(212)  
    x=[x analogThis(readVoltage(a, 'A2'))];    
    plot(x(max(1,end-300):end))
    axis([0 300 -3 3])
    t=t+passo;
    drawnow;    
end