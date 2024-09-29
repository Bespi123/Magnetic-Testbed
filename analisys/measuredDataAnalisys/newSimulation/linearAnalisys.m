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

R = diag([initial_1.Rx,initial_1.Ry,initial_1.Rz]);
B = diag([initial_1.B_x,initial_1.B_y,initial_1.B_z]);

%%% Model matrix
Ap = -inv(L1)*R ;
Bp = B*inv(L); 
Cp = eye(3);
Dp = 0;

%%% Pid values
KP = [   1380648.9719, 548580.3214, 641963.3974];
KI = [6783283495.8308, 1697252969.9689, 7238744360.0891];
KD = [0, 0, 0];

% Definir sistema en SS
sys_MIMO_1 = ss(Ap,Bp,Cp,Dp);
% Convertir el sistema en función de transferencia con salida en T
G_mimo_1 = tf(sys_MIMO_1);
% Funcion de transferencia para salida en nT
G_mimo_2 = series(G_mimo_1,1E9);

% Crear el controlador PID
C_pid_1 = pid(KP(1), KI(1), KD(1));
C_pid_2 = pid(KP(2), KI(2), KD(2));
C_pid_3 = pid(KP(3), KI(3), KD(3));

% Crear el controlador PID (nT)
C_pid_1_nT = pid(0.00042024, 2.2979, 0);
C_pid_2_nT = pid(0.00078586, 2.325, 0);
C_pid_3_nT = pid(0.00059495, 7.108, 0);

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
T1 = feedback(C_pid_1 * G_mimo_1(1,1), 1);
T2 = feedback(C_pid_2 * G_mimo_1(2,2), 1);
T3 = feedback(C_pid_3 * G_mimo_1(3,3), 1);


% Sistema en lazo cerrado con realimentación unitaria (nT)
T1_nT = feedback(C_pid_1_nT * G_mimo_2(1,1), 1);
T2_nT = feedback(C_pid_2_nT * G_mimo_2(2,2), 1);
T3_nT = feedback(C_pid_3_nT * G_mimo_2(3,3), 1);

%% Analizar controlabilidad
Co = ctrb(Ap,Bp);
rank(Co)
% Simulación de la respuesta al escalón
%step(T1);
%step(T2);
%step(T3);

% Abre la herramienta PID Tuner
%pidTuner(G_mimo_1(3), 'pid');

% % % % % %%%Extended model
% % % % % A_ex = [Ap eye(3,3); zeros(3,3), zeros(3,3)]; 
% % % % % B_ex = [Bp;zeros(3,3)];
% % % % % C_ex = [Cp, zeros(3,3)];
% % % % % 
% % % % % % Dimensión del sistema
% % % % % n = size(A_ex,1); % Número de estados (6 en este caso)
% % % % % 
% % % % % %%% Inicializar la matriz de controlabilidad
% % % % % %N = [];
% % % % % 
% % % % % %%% Generar la matriz de observabilidad
% % % % % %for i = 0:n-1
% % % % % %    N = [N, A_ex'^i*C_ex'];
% % % % % %end
% % % % % %rango = rank(N');
% % % % % N=obsv(A_ex,C_ex);
% % % % % rango = rank(N);
% % % % % 
% % % % % if rango == size(A_ex,1)
% % % % %     disp('El sistema es observable.');
% % % % % else
% % % % %     disp('El sistema NO es observable.');
% % % % % end

% The system is not observable

% % % % % %% 
% % % % % % Integral Sliding Mode Controller with RK4 Integration for 3x3 MIMO System
% % % % % % Ampliar el sistema con acción integral
% % % % % A_aug = [Ap, zeros(3,3);
% % % % %          -Cp, zeros(3,3)];
% % % % % 
% % % % % B_aug = [Bp;
% % % % %          zeros(3,3)];
% % % % % 
% % % % % C_aug = [Cp, zeros(3,3)];
% % % % % 
% % % % % % Verificar controlabilidad del sistema ampliado
% % % % % Co = ctrb(A_aug, B_aug);
% % % % % rank_Co = rank(Co);
% % % % % if rank_Co < size(A_aug,1)
% % % % %     warning('El sistema ampliado no es completamente controlable. Rango de la matriz de controlabilidad: %d', rank_Co);
% % % % % else
% % % % %     disp('El sistema ampliado es completamente controlable.');
% % % % % end
% % % % % 
% % % % % % Definir parámetros del controlador
% % % % % Ks = 10 * eye(3);        % Ganancia de deslizamiento (ajustar según necesidad)
% % % % % phi = 0.01;              % Grosor de la capa límite para reducir chattering
% % % % % 
% % % % % % Definir entrada de referencia
% % % % % r = [10; 10; 10]*1E-9;   % Entrada de referencia para cada salida (puede ser una función de tiempo)
% % % % % 
% % % % % % Condiciones iniciales
% % % % % x0 = [0; 0; 0];          % Estados iniciales
% % % % % z0 = [0; 0; 0];          % Estados integrales iniciales
% % % % % x_aug0 = [x0; z0];       % Estado aumentado inicial
% % % % % 
% % % % % % Tiempo de simulación
% % % % % t_start = 0;             % Tiempo inicial
% % % % % t_end = 10;              % Tiempo final (segundos)
% % % % % dt = 0.0001;              % Paso de tiempo (segundos)
% % % % % t = t_start:dt:t_end;    % Vector de tiempo
% % % % % 
% % % % % % Número de pasos
% % % % % N = length(t);
% % % % % 
% % % % % % Disturbio real (para simulación)
% % % % % d_actual = [10; -20; 3];   % Perturbaciones reales (para la simulación)
% % % % % 
% % % % % % Inicializar matrices para almacenar resultados
% % % % % x_aug = zeros(6, N);      % Estados aumentados [x1; x2; x3; z1; z2; z3]
% % % % % x_aug(:,1) = x_aug0;      % Asignar condiciones iniciales
% % % % % 
% % % % % u = zeros(3, N);          % Señales de control [u1; u2; u3]
% % % % % y = zeros(3, N);          % Salidas [y1; y2; y3]
% % % % % s = zeros(3, N);          % Superficies de deslizamiento [s1; s2; s3]
% % % % % 
% % % % % % Implementar el método de Runge-Kutta 4 (RK4)
% % % % % for i = 1:N-1
% % % % %     % Estado actual
% % % % %     current_state = x_aug(:,i);
% % % % % 
% % % % %     % Calcular la superficie de deslizamiento
% % % % %     s_current = C_aug * current_state - r; % s = C_aug * x_aug - r
% % % % % 
% % % % %     % Guardar la superficie de deslizamiento
% % % % %     s(:,i) = s_current;
% % % % % 
% % % % %     % Calcular la función de saturación para reducir chattering
% % % % %     sat_s = sat(s_current, phi); % 3x1
% % % % % 
% % % % %     % Calcular control deslizante
% % % % %     u_sliding = -Ks * sat_s; % 3x1
% % % % % 
% % % % %     % Calcular control equivalente
% % % % %     u_eq = -pinv(B_aug) * (A_aug * current_state + [d_actual; zeros(3,1)]); % 3x1
% % % % % 
% % % % %     % Señal de control total
% % % % %     u_total = u_eq + u_sliding; % 3x1
% % % % % 
% % % % %     % Guardar la señal de control
% % % % %     u(:,i) = u_total;
% % % % % 
% % % % %     % Definir la función de derivada para RK4
% % % % %     f = @(x_aug_state) A_aug * x_aug_state + B_aug * u_total + [d_actual; zeros(3,1)];
% % % % % 
% % % % %     % Calcular los incrementos de RK4
% % % % %     k1 = f(current_state);
% % % % %     k2 = f(current_state + 0.5*dt*k1);
% % % % %     k3 = f(current_state + 0.5*dt*k2);
% % % % %     k4 = f(current_state + dt*k3);
% % % % % 
% % % % %     % Actualizar el estado usando RK4
% % % % %     x_aug(:,i+1) = current_state + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
% % % % % 
% % % % %     % Calcular y almacenar las salidas
% % % % %     y(:,i) = C_aug * current_state;
% % % % % end
% % % % % 
% % % % % % Almacenar la última superficie de deslizamiento
% % % % % s(:,N) = C_aug * x_aug(:,N) - r;
% % % % % 
% % % % % % Almacenar la última señal de control
% % % % % u(:,N) = u(:,N-1);
% % % % % 
% % % % % % Graficar resultados
% % % % % % Estados del Sistema
% % % % % figure;
% % % % % subplot(2,1,1);
% % % % % plot(t, x_aug(1,:), 'r', 'LineWidth', 1.5); hold on;
% % % % % plot(t, x_aug(2,:), 'g', 'LineWidth', 1.5);
% % % % % plot(t, x_aug(3,:), 'b', 'LineWidth', 1.5);
% % % % % title('Estados del Sistema');
% % % % % xlabel('Tiempo (s)');
% % % % % ylabel('Valores de Estado');
% % % % % legend('x1', 'x2', 'x3');
% % % % % grid on;
% % % % % 
% % % % % % Estados Integrales
% % % % % subplot(2,1,2);
% % % % % plot(t, x_aug(4,:), 'r', 'LineWidth', 1.5); hold on;
% % % % % plot(t, x_aug(5,:), 'g', 'LineWidth', 1.5);
% % % % % plot(t, x_aug(6,:), 'b', 'LineWidth', 1.5);
% % % % % title('Estados Integrales z(t)');
% % % % % xlabel('Tiempo (s)');
% % % % % ylabel('z(t)');
% % % % % legend('z1', 'z2', 'z3');
% % % % % grid on;
% % % % % 
% % % % % % Salidas y Referencias
% % % % % figure;
% % % % % for j = 1:3
% % % % %     subplot(3,1,j);
% % % % %     plot(t, y(j,:), 'LineWidth', 1.5); hold on;
% % % % %     plot(t, r(j)*ones(size(t)), 'k--', 'LineWidth', 1.5);
% % % % %     title(sprintf('Salida y%d(t)', j));
% % % % %     xlabel('Tiempo (s)');
% % % % %     ylabel(sprintf('y%d(t)', j));
% % % % %     legend(sprintf('y%d(t)', j), sprintf('Referencia r%d(t)', j));
% % % % %     grid on;
% % % % % end
% % % % % 
% % % % % % Superficies de Deslizamiento
% % % % % figure;
% % % % % for j = 1:3
% % % % %     subplot(3,1,j);
% % % % %     plot(t, s(j,:), 'LineWidth', 1.5);
% % % % %     title(sprintf('Superficie de Deslizamiento s%d(t)', j));
% % % % %     xlabel('Tiempo (s)');
% % % % %     ylabel(sprintf('s%d(t)', j));
% % % % %     legend(sprintf('s%d(t)', j));
% % % % %     grid on;
% % % % % end
% % % % % 
% % % % % % Señales de Control
% % % % % figure;
% % % % % for j = 1:3
% % % % %     subplot(3,1,j);
% % % % %     plot(t, u(j,:), 'LineWidth', 1.5);
% % % % %     title(sprintf('Señal de Control u%d(t)', j));
% % % % %     xlabel('Tiempo (s)');
% % % % %     ylabel(sprintf('u%d(t)', j));
% % % % %     legend(sprintf('u%d(t)', j));
% % % % %     grid on;
% % % % % end
% % % % % 
% % % % % % Perturbaciones Reales
% % % % % figure;
% % % % % for j = 1:3
% % % % %     subplot(3,1,j);
% % % % %     plot(t, d_actual(j)*ones(size(t)), 'LineWidth', 1.5);
% % % % %     title(sprintf('Perturbación Real d%d(t)', j));
% % % % %     xlabel('Tiempo (s)');
% % % % %     ylabel(sprintf('d%d(t)', j));
% % % % %     legend(sprintf('d%d(t)', j));
% % % % %     grid on;
% % % % % end
% % % % % 
% % % % % % Función de saturación para la capa límite
% % % % % function sat_s = sat(s, phi)
% % % % %     sat_s = min(max(s / phi, -1), 1);
% % % % % end
% % % % % 
