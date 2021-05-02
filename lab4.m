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

G = gaussfilt(4, 20);
BB = buttfilt(6, 20);

figure(1)
plot(t, x1, 'r', t, x2, 'b', t, x0, 'y');
title('Исходные сигналы');
legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

figure(2)
plot(t, x0, 'r', t, filtfilt(G, 1, x1), 'b', t, filtfilt(G, 1, x2), 'y');
title('Фильтр частот Гауса');
legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

figure(3)
plot(t, x0, 'r', t, filtfilt(BB, 1, x1), 'b', t, filtfilt(BB, 1, x2), 'y');
title('Фильтр частот Баттерворта');
legend('Без помех', 'Гауссова помеха', 'Импульсная помеха');

function y = impnoise(size, N, mult)
    step = floor(size / N);
    y = zeros(1, size);
    for i = 0 : floor(N/2)
        y(round(size/2) + i*step) = mult * (0.5 + rand);
        y(round(size/2) - i*step) = mult * (0.5 + rand);
    end
end

function y = buttfilt(B, size)
    x = linspace(-size/2, size/2, size);
    y = 1./(1+(x./B).^4);
    y = y / sum(y);
end

function y = gaussfilt(sigma, size)
    x = linspace(-size/2, size/2, size);
    y = exp(-x.^2 / (2*sigma^2));
    y = y / sum(y);
end