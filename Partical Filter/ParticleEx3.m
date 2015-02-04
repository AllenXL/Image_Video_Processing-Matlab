function [xhatRMS, xhatPartRMS, xhatPartRegRMS] = ParticleEx3

% Particle filter example, adapted from Gordon, Salmond, and Smith paper.

x = 0.1; % initial state
Q = 0.001; % process noise covariance
R = 1; % measurement noise covariance
tf = 50; % simulation length

N = 3; % number of particles in the particle filter
NReg = 5 * N; % number of probability bins in the regularized particle filter

xhat = x;
P = 2;
xhatPart = x;
xhatPartReg = x;

% Initialize the particle filter.
for i = 1 : N
    xpart(i) = x + sqrt(P) * randn; % normal particle filter
    xpartReg(i) = xpart(i); % regularized particle filter
end

% Initialization for the regularized particle filter.
d = length(x); % dimension of the state vector
c = 2; % volume of unit hypersphere in d-dimensional space
h = (8 * c^(-1) * (d + 4) * (2 * sqrt(pi))^d)^(1 / (d + 4)) * N^(-1 / (d + 4)); % bandwidth of regularized filter

% Initialize arrays.
xArr = [x];
yArr = [x^2 / 20 + sqrt(R) * randn];
xhatArr = [x];
PArr = [P];
xhatPartArr = [xhatPart];
xhatPartRegArr = [xhatPartReg];

close all; % close all open figures

for k = 1 : tf
    % System simulation
    x = 0.5 * x + 25 * x / (1 + x^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn;
    y = x^2 / 20 + sqrt(R) * randn;
    % Extended Kalman filter
    F = 0.5 + 25 * (1 - xhat^2) / (1 + xhat^2)^2;
    P = F * P * F' + Q;
    H = xhat / 10;
    K = P * H' * (H * P * H' + R)^(-1);
    xhat = 0.5 * xhat + 25 * xhat / (1 + xhat^2) + 8 * cos(1.2*(k-1));
    xhat = xhat + K * (y - xhat^2 / 20);
    P = (1 - K * H) * P;
    % Particle filter
    for i = 1 : N
        xpartminus(i) = 0.5 * xpart(i) + 25 * xpart(i) / (1 + xpart(i)^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn;
        ypart = xpartminus(i)^2 / 20;
        vhat = y - ypart;
        q(i) = (1 / sqrt(R) / sqrt(2*pi)) * exp(-vhat^2 / 2 / R);
    end
    % Normalize the likelihood of each a priori estimate.
    qsum = sum(q);
    for i = 1 : N
        q(i) = q(i) / qsum;
    end
    % Resample.
    for i = 1 : N
        u = rand; % uniform random number between 0 and 1
        qtempsum = 0;
        for j = 1 : N
            qtempsum = qtempsum + q(j);
            if qtempsum >= u
                xpart(i) = xpartminus(j);
                break;
            end
        end
    end
    % The particle filter estimate is the mean of the particles.
    xhatPart = mean(xpart);
    % Now run the regularized particle filter.
    % Perform the time update to the get the a priori regularized particles.
    for i = 1 : N
        xpartminusReg(i) = 0.5 * xpartReg(i) + 25 * xpartReg(i) / (1 + xpartReg(i)^2) + 8 * cos(1.2*(k-1)) + sqrt(Q) * randn;
        ypart = xpartminusReg(i)^2 / 20;
        vhat = y - ypart;
        q(i) = (1 / sqrt(R) / sqrt(2*pi)) * exp(-vhat^2 / 2 / R);
    end
    % Normalize the probabilities of the a priori particles.
    q = q / sum(q);
    % Compute the covariance of the a priori particles.
    S = cov(xpartminusReg');
    A = chol(S)';
    % Define the domain from which we will choose a posteriori particles for
    % the regularized particle filter.
    xreg(1) = min(xpartminusReg) - std(xpartminusReg);
    xreg(NReg) = max(xpartminusReg) + std(xpartminusReg);
    dx = (xreg(NReg) - xreg(1)) / (NReg - 1);
    for i = 2 : NReg - 1
        xreg(i) = xreg(i-1) + dx;
    end
    % Create the pdf approximation that is required for the regularized
    % particle filter.
    for j = 1 : NReg
        qreg(j) = 0;
        for i = 1 : N
            normx = norm(inv(A) * (xreg(j) - xpartminusReg(i)));
            if normx < h
                qreg(j) = qreg(j) + q(i) * (d + 2) * (1 - normx^2 / h^2) / 2 / c / h^d / det(A);
            end
        end
    end
    % Normalize the likelihood of each state estimate for the regularized particle filter.
    qsum = sum(qreg);
    for j = 1 : NReg
        qreg(j) = qreg(j) / qsum;
    end
    % Resample for the regularized particle filter.
    for i = 1 : N
        u = rand; % uniform random number between 0 and 1
        qtempsum = 0;
        for j = 1 : NReg
            qtempsum = qtempsum + qreg(j);
            if qtempsum >= u
                xpartReg(i) = xreg(j);
                break;
            end
        end
    end
    % The regularized particle filter estimate is the mean of the regularized particles.
    xhatPartReg = mean(xpartReg);
    % Plot the discrete pdf and the continuous pdf at a specific time.
    if k == 5
        figure; hold on;
        for i = 1 : N
            plot([xpartminusReg(i) xpartminusReg(i)], [0 q(i)], 'k-');
            plot(xpartminusReg(i), q(i), 'ko');
        end
        plot(xreg, qreg, 'r:');
        set(gca,'FontSize',12); set(gcf,'Color','White'); 
        set(gca,'box','on');
        xlabel('state estimate'); ylabel('pdf');
    end
    % Save data in arrays for later plotting
    xArr = [xArr x];
    yArr = [yArr y];
    xhatArr = [xhatArr xhat];
    PArr = [PArr P];
    xhatPartArr = [xhatPartArr xhatPart];
    xhatPartRegArr = [xhatPartRegArr xhatPartReg];
end

t = 0 : tf;

%figure;
%plot(t, xArr);
%ylabel('true state');

figure;
plot(t, xArr, 'b.', t, xhatArr, 'k-', t, xhatArr-2*sqrt(PArr), 'r:', t, xhatArr+2*sqrt(PArr), 'r:');
axis([0 tf -40 40]);
set(gca,'FontSize',12); set(gcf,'Color','White'); 
xlabel('time step'); ylabel('state');
legend('True state', 'EKF estimate', '95% confidence region'); 

figure;
plot(t, xArr, 'b.', t, xhatPartArr, 'k-', t, xhatPartRegArr, 'r:');
set(gca,'FontSize',12); set(gcf,'Color','White'); 
xlabel('time step'); ylabel('state');
legend('True state', 'Particle filter', 'Regularized particle filter'); 

xhatRMS = sqrt((norm(xArr - xhatArr))^2 / tf);
xhatPartRMS = sqrt((norm(xArr - xhatPartArr))^2 / tf);
xhatPartRegRMS = sqrt((norm(xArr - xhatPartRegArr))^2 / tf);
disp(['Kalman filter RMS error = ', num2str(xhatRMS)]);
disp(['Particle filter RMS error = ', num2str(xhatPartRMS)]);
disp(['Regularized particle filter RMS error = ', num2str(xhatPartRegRMS)]);
