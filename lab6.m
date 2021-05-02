sigma = 0.5;
A = 1;

mult = 5;
step = 0.005;
t = -mult:step:mult;

% Исходный полезный сигнал: Гаусс
x0 = A * exp(-(t/sigma).^2);

% Генерация гауссовской помехи
n1 = normrnd(0, 0.05, [1 length(x0)]);
% Результирующий сигнал
x1 = x0 + n1;

% Генерация импульсной помехи
count = 5;
M = 0.2;
n2 = impnoise(length(x0), count, M);
% Результирующий сигнал
x2 = x0 + n2;

y1 = wiener(fft(x1), fft(n1));
y2 = wiener(fft(x2), fft(n2));

figure(1)
plot(t, x1, 'r', t, x2, 'b', t, x0, 'y');
title('Исходные сигналы');
legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

figure(2)
plot(t, x1, 'r', t, ifft(fft(x1).*y1), 'b');
title('Фильтр Виньера для сигнала с гаусовыми помехами');
legend('Исходный','Фильтрованный');

figure(3)
plot(t, x2, 'r', t, ifft(fft(x2).*y2), 'b');
title('Фильтр Виньера для сигнала с импульсными помехами');
legend('Исходный','Фильтрованный');

function y = impnoise(size, N, mult)
    step = floor(size / N);
    y = zeros(1, size);
    for i = 0 : floor(N/2)
        y(round(size/2) + i*step) = mult * (0.5 + rand);
        y(round(size/2) - i*step) = mult * (0.5 + rand);
    end
end

function y = wiener(x, n)
    y = 1 - (n./x).^2;
end