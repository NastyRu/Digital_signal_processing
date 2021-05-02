NS = 0.05;
mult = 5;
step = 0.005;
t = -mult:step:mult;

% Сигналы на входе u1, и выходе u2
u1 = exp(-(t/2).^2);
u2 = exp(-(t/1.5).^2);

% Преобразование Фурье
v1 = fft(u1);
v2 = fft(u2);

% Генерация гауссовской помехи
n = normrnd(0, 0.05, [1 length(t)]);

delta = max(u1) * 0.05;
epsilon = max(u1) * 0.05;

figure(1);
plot(t, u1 + n, 'r', t, u2 + n, 'b', t, abs(ifft(fft(u2 + n) .* tikhonfilt(v1, v2, step, 2 * mult, delta, epsilon))), 'g');
legend('Сигнал на входе в фильтр', 'Сигнал на выходе из фильтра', 'Сигнал импульсного отклика');

% Функция импульсного отклика
function h = tikhonfilt(v1, v2, dx, T, delta, epsilon)
    m = 0:length(v1)-1;
    squ = 1 + (2 * pi * m / T).^2;
    % Ищем корень в интервале
    func = @(x) rho(x, v1, v2, dx, T, delta, epsilon);
    alpha = fzero(func, [0, 1]);
    h = 0:length(v1)-1;
    for k = 1:length(h)
        h(k) = dx / length(v1) * sum(exp(2 * pi * 1i * k .* m / length(v1)) .* v1 .* conj(v2) ./ (abs(v2).^2 .* dx^2 + alpha * squ), 2);
    end
end

% Решение методом невязки
function y = rho(x, v1, v2, dx, T, delta, epsilon)
    m = 0:length(v1)-1;
    squ = 1 + (2 * pi * m / T).^2;
    beta = dx / length(v1) * sum(x.^2 * squ .* abs(v1).^2 ./ (abs(v2).^2 * dx^2 + x .* squ).^2, 2);
    gamma = dx / length(v1) * sum(abs(v2).^2 * dx^2 .* abs(v1).^2 .* squ ./ (abs(v2).^2 * dx^2 + x * (1 + 2 * pi * m / T).^2).^2, 2);
    y = beta - (delta + epsilon * sqrt(gamma))^2;
end