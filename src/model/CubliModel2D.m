classdef CubliModel2D
    properties
        mb; mw; lb; l; Ib; Iw; g;
        Cb; Cw; Km;
    end

    methods
        function obj = CubliModel2D(modelParam)
            obj.mb = modelParam.mb;
            obj.mw = modelParam.mw;
            obj.lb = modelParam.lb;
            obj.l  = modelParam.l;
            obj.Ib = modelParam.Ib;
            obj.Iw = modelParam.Iw;
            obj.g  = modelParam.g;
            obj.Cb = modelParam.Cb;
            obj.Cw = modelParam.Cw;
            obj.Km = modelParam.Km;
        end

        function dx = dynamics(obj, x, u)
            % state space: [\theta_b, \dot{\thate_b}, \theta_w, \dot{\theta_w}]
            theta_b = x(1);
            dtheta_b = x(2);
            theta_w = x(3);
            dtheta_w = x(4);

            % Input torque from motor
            Tm = obj.Km * u;

            % Constants
            A = (obj.mb*obj.lb + obj.mw*obj.l) * obj.g * sin(theta_b);
            denom = (obj.Ib + obj.mw * obj.l^2);

            % system dynamics
            ddtheta_b = (A - Tm - obj.Cb*dtheta_b + obj.Cw*dtheta_w) / denom;

            ddtheta_w = ((obj.Ib + obj.Iw + obj.mw*obj.l^2)*(Tm - obj.Cw*dtheta_w) ...
                        - (obj.Iw + obj.mw*obj.l^2)*(obj.Cb*dtheta_b + (obj.mb*obj.lb + obj.mw*obj.l)*obj.g*sin(theta_b))) ...
                        / (obj.Iw * (obj.Ib + obj.mw*obj.l^2));

            dx = [dtheta_b; ddtheta_b; dtheta_w; ddtheta_w];
        end
    end
end