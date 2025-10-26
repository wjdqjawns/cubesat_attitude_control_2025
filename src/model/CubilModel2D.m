classdef CubilModel2D
    properties
        m; l; J; g;
    end
    methods
        function obj = CubilModel2D(param)
            obj.m = param.m;
            obj.l = param.l;
            obj.J = param.J;
            obj.g = param.g;
        end

        function dx = dynamics(obj, x, u)
            theta = x(1);
            dtheta = x(2);
            ddtheta = (obj.m*obj.g*obj.l*sin(theta) - u) / obj.J;
            dx = [dtheta; ddtheta];
        end
    end
end
