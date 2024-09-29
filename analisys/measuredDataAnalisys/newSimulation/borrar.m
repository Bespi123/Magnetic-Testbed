% Definición de matrices A y Q
A = [0, 1; -4, -2];  % Ejemplo de matriz A
Q = [1, 0; 0, 1];  % Ejemplo de matriz Q

% Resolver la ecuación de Lyapunov PA + A^T P = -Q
%P = lyap(A, A', -Q);
P = lyap(eye(2),Q,[],A')

% Mostrar el resultado
disp('La matriz P es:');
disp(P);