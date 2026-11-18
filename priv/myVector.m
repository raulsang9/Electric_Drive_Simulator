function myVector(v0, v, color, lw, headLength, headWidth)

x0 = real(v0);
y0 = imag(v0);

x = real(v);
y = imag(v);

alpha = atan2(y,x);

% punto donde termina la línea (antes de la punta)
x_line = x - headLength*cos(alpha);
y_line = y - headLength*sin(alpha);

% dibujar línea desde v0
plot([x0 x0 + x_line],[y0 y0 + y_line],'Color',color,'LineWidth',lw)
hold on

% triángulo de la flecha
p = [0 0;
    -headLength  headWidth;
    -headLength -headWidth]';

% rotación
R = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];

p_rot = R*p;

% trasladar a la punta (v0 + v)
p_rot(1,:) = p_rot(1,:) + x0 + x;
p_rot(2,:) = p_rot(2,:) + y0 + y;

patch(p_rot(1,:),p_rot(2,:),color,'EdgeColor',color)

end