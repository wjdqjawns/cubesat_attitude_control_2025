classdef PIDController
    properties
        Kp; Ki; Kd;
        prev_error = 0;
        integral = 0;
    end
    methods
        function obj = PIDController(param)
            obj.Kp = param.Kp;
            obj.Ki = param.Ki;
            obj.Kd = param.Kd;
        end

        function [u, obj] = compute(obj, error, dt)
            obj.integral = obj.integral + error * dt;
            derivative = (error - obj.prev_error) / dt;
            u = obj.Kp*error + obj.Ki*obj.integral + obj.Kd*derivative;
            obj.prev_error = error;
        end
    end
end