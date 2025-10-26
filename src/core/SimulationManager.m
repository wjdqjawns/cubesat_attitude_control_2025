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

            x = [deg2rad(10); 0; 0; 0]; % initial angle
            ref = 0;

            t = zeros(steps,1);
            x_hist = zeros(steps,4);
            u_hist = zeros(steps,1);

            for k = 1:steps
                error = ref - x(1);
                [u, obj.controller] = obj.controller.compute(error, dt);
                dx = obj.model.dynamics(x, u);
                x = x + dx*dt; % Euler integration

                % save info
                t(k) = (k-1)*dt;
                x_hist(k,:) = x';
                u_hist(k) = u;
            end

            % save results
            results = struct( ...
                't', t, ...
                'x_hist', x_hist, ...
                'u_hist', u_hist ...
            );

            save(obj.cfg.meta.filename.mat, "results");
        end
    end
end
