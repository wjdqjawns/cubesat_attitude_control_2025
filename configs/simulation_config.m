%% ========================================================================
%  File: simulation_config.m
%  Project: Cubli Simulation (MATLAB)
%  Description:
%      Configuration file defining simulation environment, model parameters,
%      controller gains, and auto-generated experiment directories.
%
%  Author: Beomjun Jung (정범준)
%  Affiliation: DGIST, School of Mechanical Engineering
%  Email: dgist22_jbj@dgist.ac.kr
%
%  Created Date : 2025-10-26
%  Last Updated : 2025-10-26
%  Version      : v1.0
%
%  Revision History:
%    v1.0 (2025-10-26) - Initial implementation for Cubli simulation
%    v1.1 (TBD)        - Add adaptive noise model & configurable export paths
%
%  Dependencies:
%      - None (self-contained)
%      - Automatically creates output directories if not exist
%
%  Usage:
%      >> cfg = simulation_config();
%      Returns a configuration struct containing all parameters.
%
%  Notes:
%      - Supports 'PID' or 'LQR' control
%      - Automatically names experiment folders with timestamp
%
%  ========================================================================

function cfg = simulation_config()
    %---------------------------------------------
    % 1) simulation environments
    %---------------------------------------------
    cfg.simulation.dt = 0.001;      % time interval (sec)
    cfg.simulation.duration = 5.0;  % simulation time (sec)
    cfg.simulation.noise_std = 0.01; % noise distribution

    %---------------------------------------------
    % 2) model param
    %---------------------------------------------
    cfg.model.m = 0.5;  % mass (kg)
    cfg.model.l = 0.04; % length of center (m)
    cfg.model.J = 0.002; % momentum of inertia (kg·m^2)
    cfg.model.g = 9.81; % gravity (m/s^2)

    %---------------------------------------------
    % 3) controller (PID or LQR)
    %---------------------------------------------
    cfg.controller.type = 'PID'; % 'PID' or 'LQR'

    % pid controller param
    cfg.controller.PID.Kp = 12;
    cfg.controller.PID.Ki = 0.0;
    cfg.controller.PID.Kd = 1.2;

    % lqr controller param
    cfg.controller.LQR.Q = diag([20, 1]);
    cfg.controller.LQR.R = 0.5;

    %---------------------------------------------
    % 4) save location and file name
    %---------------------------------------------
    timestamp = string(datetime("now", 'Format', 'yyyyMMdd_HHmmss'));
    sim_name = sprintf('%s_%s', cfg.controller.type, timestamp);

    root_dir = fileparts(mfilename('fullpath'));           % configs/
    project_root = fullfile(root_dir, '..');               % simulation/matlab/
    exp_root = fullfile(project_root, 'experiments');      % experiments/

    % experiments folder structure define
    cfg.meta.path.results = fullfile(exp_root, 'results');
    cfg.meta.path.figures = fullfile(exp_root, 'figures');
    cfg.meta.path.logs    = fullfile(exp_root, 'logs');
    cfg.meta.path.model   = fullfile(exp_root, 'model');

    % mkdir folder if not exist
    fields = fieldnames(cfg.meta.path);
    for i = 1:numel(fields)
        folder = cfg.meta.path.(fields{i});
        if ~exist(folder, 'dir')
            mkdir(folder);
        end
    end

    % file name format
    cfg.meta.filename = struct( ...
        'mat',  fullfile(cfg.meta.path.results, [sim_name '.mat']), ...
        'fig',  fullfile(cfg.meta.path.figures, [sim_name '.png']), ...
        'log',  fullfile(cfg.meta.path.logs,    [sim_name '.csv']), ...
        'model',fullfile(cfg.meta.path.model,   [sim_name '_params.mat']) ...
    );

    % meta data
    cfg.meta.sim_name = sim_name;
    cfg.meta.created_at = timestamp;
end