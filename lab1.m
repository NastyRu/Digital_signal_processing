sigma = 1;
L = 1;
A = 1;

n = input('Введите количество точек: ');
dx = input('Введите шаг: ');

% Дискретные значения
x_max = dx * (n - 1) / 2;
xd = -x_max : dx : x_max;
rd = zeros(size(xd));
rd(abs(xd) <= L) = 1;
gd = A * exp(-(xd / sigma).^2);

% Исходный
x = -x_max : 0.001 : x_max;
rs = zeros(size(x));
rs(abs(x) <= L) = 1;
gs = A * exp(-(x / sigma).^2);

% Восстановленный
rr = zeros(1, length(x));
gr = zeros(1, length(x));
for i = 1 : length(x)
   for j = 1 : n
       rr(i) = rr(i) + rd(j) * sinc((x(i) - xd(j)) / dx);
       gr(i) = gr(i) + gd(j) * sinc((x(i) - xd(j)) / dx);
   end
end

figure;
title('Функция Гаусса');
hold on;
grid on;
plot(x, gs, 'r');
plot(x, gr, 'g');
legend('Исходный сигнал', 'Восстановленный');

figure;
title('Прямоугольный импульс');
hold on;
grid on;
plot(x, rs, 'r');
plot(x, rr, 'g');
legend('Исходный сигнал', 'Восстановленный');