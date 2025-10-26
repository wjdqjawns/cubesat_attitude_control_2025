classdef SimulationManager
    properties
        model;
        controller;
        cfg;
        results;
    end
    methods
        function obj = SimulationManager(model, controller, cfg)
            obj.model = model;
            obj.controller = controller;
            obj.cfg = cfg;
        end

        function results = run(obj)
            dt = obj.cfg.simulation.dt;
            T = obj.cfg.simulation.duration;
            steps = T/dt;

            x = [deg2rad(10); 0]; % initial angle
            ref = 0;
            time = zeros(steps,1);
            state_hist = zeros(steps,2);
            u_hist = zeros(steps,1);

            for k = 1:steps
                t = (k-1)*dt;
                error = ref - x(1);
                [u, obj.controller] = obj.controller.compute(error, dt);
                dx = obj.model.dynamics(x, u);
                x = x + dx*dt; % Euler integration

                % save info
                time(k) = t;
                state_hist(k,:) = x';
                u_hist(k) = u;
            end

            % save results
            results = struct( ...
                'time', time, ...
                'state', state_hist, ...
                'input', u_hist ...
            );

            save(obj.cfg.meta.filename.mat, "results");
        end
    end
end
