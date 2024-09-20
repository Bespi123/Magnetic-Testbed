%%% Linear Analisys
%X_dot = Ap*X+Bp*U
%    Y = Cp*X + Dp*U
parameters

L1 =[initial_1.Lx, (initial_1.B_x/initial_1.B_y)*initial_1.Lxy, (initial_1.B_x/initial_1.B_z)*initial_1.Lxz;
     (initial_1.B_y/initial_1.B_x)*initial_1.Lxy,initial_1.Ly, (initial_1.B_y/initial_1.B_z)*initial_1.Lzy;
     (initial_1.B_z/initial_1.B_x)*initial_1.Lxz,(initial_1.B_z/initial_1.B_y)*initial_1.Lzy,initial_1.Lz];

L = [initial_1.Lx,initial_1.Lxy,initial_1.Lxz;
     initial_1.Lxy,initial_1.Ly,initial_1.Lzy;
     initial_1.Lxz,initial_1.Lzy,initial_1.Lz];
%L = diag([initial_1.Lx,initial_1.Ly,initial_1.Lz]);
R = diag([initial_1.Rx,initial_1.Ry,initial_1.Rz]);
B = diag([initial_1.B_x,initial_1.B_y,initial_1.B_z]);
%%% Model matrix
Ap = -inv(L1)*R ;
Bp = B*inv(L); 
Cp = [1,1,1];
Dp = 0;
%%% Pid values
KP = [   1380648.9719, 548580.3214, 641963.3974];
KI = [6783283495.8308, 1697252969.9689, 7238744360.0891];
KD = [0, 0, 0];

% Definis sistema en SS
sys_MIMO_1 = ss(Ap,Bp,Cp,Dp);
% Convertir el sistema en función de transferencia
G_mimo_1 = tf(sys_MIMO_1);

% Crear el controlador PID
C_pid_1 = pid(KP(1), KI(1), KD(1));
C_pid_2 = pid(KP(2), KI(2), KD(2));
C_pid_3 = pid(KP(3), KI(3), KD(3));

% Encuentra los polos del lazo abierto 
p = pole(G_mimo_1);
% Graficar la respuesta al escalón del sistema SISO en lazo cerrado
step(G_mimo_1);

% Mostrar los polos
disp('Polos del lazo MIMO:');
disp(p);

% Verificar estabilidad
if all(real(p) < 0)
    disp('El lazo SISO es estable.');
else
    disp('El lazo SISO es inestable.');
end

%PID 
% Sistema en lazo cerrado con realimentación unitaria
T1 = feedback(C_pid_1 * G_mimo_1(1), 1);
T2 = feedback(C_pid_2 * G_mimo_1(2), 1);
T3 = feedback(C_pid_3 * G_mimo_1(3), 1);

% Simulación de la respuesta al escalón
step(T1);
step(T2);
step(T3);

% Abre la herramienta PID Tuner
%pidTuner(G_mimo_1(3), 'pid');

% Definir las matrices del sistema
%Ap = [0 1 0; 0 0 1; -2 -3 -4]; % Ejemplo de matriz 3x3
%Bp = [1 0 0; 0 1 0; 0 0 1];    % Ejemplo de matriz 3x3
%Cp = [1 1 1];                  % Matriz de salida 1x3
%Dp = 0;                        % Matriz D del sistema

% Ganancias del observador (puedes ajustar estos valores)
L = [10; 10; 10];  % Ganancia del observador, ajustable

% Tiempo de simulación
dt = 0.01;
T = 10;
t = 0:dt:T;

% Inicializar las variables
x_hat = [0; 0; 0];  % Estimación inicial del estado
d_hat = 0;          % Estimación inicial de la perturbación
x_real = [0; 0; 0]; % Estado real inicial del sistema
u = [0; 0; 0];      % Entrada inicial (puedes ajustarla)

% Simulación
for k = 1:length(t)
    % Sistema real
    x_real_dot = Ap * x_real + Bp * u;
    x_real = x_real + x_real_dot * dt;
    
    % Salida real
    y_real = Cp * x_real;
    
    % Observador de estado y perturbación
    x_hat_dot = Ap * x_hat + Bp * u + L * (y_real - Cp * x_hat);
    x_hat = x_hat + x_hat_dot * dt;
    
    % Estimación de la perturbación
    d_hat_dot = 0; % Si asumimos que la perturbación es constante
    d_hat = d_hat + d_hat_dot * dt;
    
    % Almacenar resultados
    x_real_history(:,k) = x_real;
    x_hat_history(:,k) = x_hat;
    d_hat_history(k) = d_hat;
end

% Graficar los resultados
figure;
subplot(3, 1, 1);
plot(t, x_real_history(1,:), 'r', t, x_hat_history(1,:), 'b--');
title('Estado 1 del sistema');
legend('Estado real', 'Estado estimado');
xlabel('Tiempo (s)');
ylabel('Valor');

subplot(3, 1, 2);
plot(t, x_real_history(2,:), 'r', t, x_hat_history(2,:), 'b--');
title('Estado 2 del sistema');
legend('Estado real', 'Estado estimado');
xlabel('Tiempo (s)');
ylabel('Valor');

subplot(3, 1, 3);
plot(t, d_hat_history, 'b--');
title('Estimación de la perturbación');
xlabel('Tiempo (s)');
ylabel('Valor de perturbación');
% Definir las matrices del sistema
Ap = [0 1 0; 0 0 1; -2 -3 -4]; % Ejemplo de matriz 3x3
Bp = [1 0 0; 0 1 0; 0 0 1];    % Ejemplo de matriz 3x3
Cp = [1 1 1];                  % Matriz de salida 1x3
Dp = 0;                        % Matriz D del sistema

% Ganancias del observador (puedes ajustar estos valores)
L = [10; 10; 10];  % Ganancia del observador, ajustable

% Tiempo de simulación
dt = 0.01;
T = 10;
t = 0:dt:T;

% Inicializar las variables
x_hat = [0; 0; 0];  % Estimación inicial del estado
d_hat = 0;          % Estimación inicial de la perturbación
x_real = [1; 0; 0]; % Estado real inicial del sistema
u = [0; 0; 0];      % Entrada inicial (puedes ajustarla)

% Simulación
for k = 1:length(t)
    % Sistema real
    x_real_dot = Ap * x_real + Bp * u;
    x_real = x_real + x_real_dot * dt;
    
    % Salida real
    y_real = Cp * x_real;
    
    % Observador de estado y perturbación
    x_hat_dot = Ap * x_hat + Bp * u + L * (y_real - Cp * x_hat);
    x_hat = x_hat + x_hat_dot * dt;
    
    % Estimación de la perturbación
    d_hat_dot = 0; % Si asumimos que la perturbación es constante
    d_hat = d_hat + d_hat_dot * dt;
    
    % Almacenar resultados
    x_real_history(:,k) = x_real;
    x_hat_history(:,k) = x_hat;
    d_hat_history(k) = d_hat;
end

% Graficar los resultados
figure;
subplot(3, 1, 1);
plot(t, x_real_history(1,:), 'r', t, x_hat_history(1,:), 'b--');
title('Estado 1 del sistema');
legend('Estado real', 'Estado estimado');
xlabel('Tiempo (s)');
ylabel('Valor');

subplot(3, 1, 2);
plot(t, x_real_history(2,:), 'r', t, x_hat_history(2,:), 'b--');
title('Estado 2 del sistema');
legend('Estado real', 'Estado estimado');
xlabel('Tiempo (s)');
ylabel('Valor');

subplot(3, 1, 3);
plot(t, d_hat_history, 'b--');
title('Estimación de la perturbación');
xlabel('Tiempo (s)');
ylabel('Valor de perturbación');
