function cfg = simulation_config()
% 설정파일 역할을 하는 MATLAB 함수
% 실행 시 cfg 구조체를 반환함

    %---------------------------------------------
    % 1) 시뮬레이션 환경 설정
    %---------------------------------------------
    cfg.simulation.dt = 0.001;      % 시간 간격
    cfg.simulation.duration = 5.0;  % 시뮬레이션 전체 시간 (초)
    cfg.simulation.noise_std = 0.01; % 외란 노이즈 표준편차

    %---------------------------------------------
    % 2) 모델 파라미터
    %---------------------------------------------
    cfg.model.m = 0.5;  % 질량 (kg)
    cfg.model.l = 0.04; % 중심까지 거리 (m)
    cfg.model.J = 0.002; % 관성모멘트 (kg·m^2)
    cfg.model.g = 9.81; % 중력가속도 (m/s^2)

    %---------------------------------------------
    % 3) 제어기 선택 (PID or LQR)
    %---------------------------------------------
    cfg.controller.type = 'PID'; % 'PID' or 'LQR'

    % PID 제어기 설정
    cfg.controller.PID.Kp = 12;
    cfg.controller.PID.Ki = 0.0;
    cfg.controller.PID.Kd = 1.2;

    % LQR 제어기 설정
    cfg.controller.LQR.Q = diag([20, 1]);
    cfg.controller.LQR.R = 0.5;

    %---------------------------------------------
    % 4) 시뮬레이션 이름 (저장용)
    %---------------------------------------------
    cfg.meta.name = sprintf('sim_%s_%s', ...
        cfg.controller.type, datestr(now,'HHMMSS'));
end