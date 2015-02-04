function [xArray, xhatArray] = ParticleEx2

% Particle filter example.
% Track a body falling through the atmosphere.
% This system is taken from [Jul00], which was based on [Ath68].

rho0 = 2; % lb-sec^2/ft^4
g = 32.2; % ft/sec^2
k = 2e4; % ft
R = 10^4; % measurement noise variance (ft^2)
Q = diag([0 0 0]); % process noise covariance
M = 10^5; % horizontal range of position sensor
a = 10^5; % altitude of position sensor
P = diag([1e6 4e6 10]); % initial estimation error covariance

x = [3e5; -2e4; 1e-3]; % initial state
xhat = [3e5; -2e4; 1e-3]; % initial state estimate

N = 100; % number of particles  

% Initialize the particle filter.
for i = 1 : N
    xhatplus(:,i) = x + sqrt(P) * [randn; randn; randn];
end

T = 0.5; % measurement time step
randn('state',sum(100*clock)); % random number generator seed

tf = 30; % simulation length (seconds)
dt = 0.04; % time step for integration (seconds)
xArray = x;
xhatArray = xhat;

for t = T : T : tf
    fprintf('.');
    % Simulate the system.
    for tau = dt : dt : T
        % Fourth order Runge Kutta ingegration
        dx1(1,1) = x(2);
        dx1(2,1) = rho0 * exp(-x(1)/k) * x(2)^2 / 2 * x(3) - g;
        dx1(3,1) = 0;
        dx1 = dx1 * dt;
        xtemp = x + dx1 / 2;
        dx2(1,1) = xtemp(2);
        dx2(2,1) = rho0 * exp(-xtemp(1)/k) * xtemp(2)^2 / 2 * xtemp(3) - g;
        dx2(3,1) = 0;
        dx2 = dx2 * dt;
        xtemp = x + dx2 / 2;
        dx3(1,1) = xtemp(2);
        dx3(2,1) = rho0 * exp(-xtemp(1)/k) * xtemp(2)^2 / 2 * xtemp(3) - g;
        dx3(3,1) = 0;
        dx3 = dx3 * dt;
        xtemp = x + dx3;
        dx4(1,1) = xtemp(2);
        dx4(2,1) = rho0 * exp(-xtemp(1)/k) * xtemp(2)^2 / 2 * xtemp(3) - g;
        dx4(3,1) = 0;
        dx4 = dx4 * dt;
        x = x + (dx1 + 2 * dx2 + 2 * dx3 + dx4) / 6;
        x = x + sqrt(dt * Q) * [randn; randn; randn] * dt;
    end
    % Simulate the noisy measurement.
    z = sqrt(M^2 + (x(1)-a)^2) + sqrt(R) * randn;
    % Simulate the continuous-time part of the particle filter (time update).
    xhatminus = xhatplus;
    for i = 1 : N
        for tau = dt : dt : T
            % Fourth order Runge Kutta ingegration
            xtemp = xhatminus(:,i);
            dx1(1,1) = xtemp(2);
            dx1(2,1) = rho0 * exp(-xtemp(1)/k) * xtemp(2)^2 / 2 * xtemp(3) - g;
            dx1(3,1) = 0;
            dx1 = dx1 * dt;
            xtemp = xhatminus(:,i) + dx1 / 2;
            dx2(1,1) = xtemp(2);
            dx2(2,1) = rho0 * exp(-xtemp(1)/k) * xtemp(2)^2 / 2 * xtemp(3) - g;
            dx2(3,1) = 0;
            dx2 = dx2 * dt;
            xtemp = xhatminus(:,i) + dx2 / 2;
            dx3(1,1) = xtemp(2);
            dx3(2,1) = rho0 * exp(-xtemp(1)/k) * xtemp(2)^2 / 2 * xtemp(3) - g;
            dx3(3,1) = 0;
            dx3 = dx3 * dt;
            xtemp = xhatminus(:,i) + dx3;
            dx4(1,1) = xtemp(2);
            dx4(2,1) = rho0 * exp(-xtemp(1)/k) * xtemp(2)^2 / 2 * xtemp(3) - g;
            dx4(3,1) = 0;
            dx4 = dx4 * dt;
            xhatminus(:,i) = xhatminus(:,i) + (dx1 + 2 * dx2 + 2 * dx3 + dx4) / 6;
            xhatminus(:,i) = xhatminus(:,i) + sqrt(dt * Q) * [randn; randn; randn] * dt;
            xhatminus(3,i) = max(0, xhatminus(3,i)); % the ballistic coefficient cannot be negative
        end
        zhat = sqrt(M^2 + (xhatminus(1,i)-a)^2);
        vhat(i) = z - zhat;
    end
    % Note that we need to scale all of the q(i) probabilities in a way
    % that does not change their relative magnitudes.
    % Otherwise all of the q(i) elements will be zero because of the
    % large value of the exponential.
    vhatscale = max(abs(vhat)) / 4;
    qsum = 0;
    for i = 1 : N
        q(i) = exp(-(vhat(i)/vhatscale)^2);
        qsum = qsum + q(i);
    end
    % Normalize the likelihood of each a priori estimate.
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
                xhatplus(:,i) = xhatminus(:,j);
                % Use roughening to prevent sample impoverishment.
                E = max(xhatminus')' - min(xhatminus')';
                sigma = 0.2 * E * N^(-1/length(x));
                xhatplus(:,i) = xhatplus(:,i) + sigma .* [randn; randn; randn];
                xhatplus(3,i) = max(0,xhatplus(3,i)); % the ballistic coefficient cannot be negative
                break;
            end
        end
    end
    % The particle filter estimate is the mean of the particles.
    xhat = 0;
    for i = 1 : N
        xhat = xhat + xhatplus(:,i);
    end
    xhat = xhat / N;
    % Save data for plotting.
    xArray = [xArray x];
    xhatArray = [xhatArray xhat];
end

close all;
t = 0 : T : tf;
figure; 
semilogy(t, abs(xArray(1,:) - xhatArray(1,:)), 'b'); hold;
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('Seconds');
ylabel('Altitude Estimation Error');

figure; 
semilogy(t, abs(xArray(2,:) - xhatArray(2,:)), 'b'); hold;
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('Seconds');
ylabel('Velocity Estimation Error');

figure; 
semilogy(t, abs(xArray(3,:) - xhatArray(3,:)), 'b'); hold;
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('Seconds');
ylabel('Ballistic Coefficient Estimation Error');

figure;
plot(t, xArray(1,:));
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('Seconds');
ylabel('True Position');

figure;
plot(t, xArray(2,:));
title('Falling Body Simulation', 'FontSize', 12);
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('Seconds');
ylabel('True Velocity');
