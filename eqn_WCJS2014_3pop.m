% Three-population Wilson-Cowan model (E, SOM, PV), based on Veit et al., 2017
% y(1) = r_E, y(2) = r_SOM, y(3) = r_PV

function dy = eqn_WCJS2014_3pop(~, y, wcParams, stimParams)

dy = zeros(3,1);

dy(1) = ( -y(1) + threshLinear( ...
    wcParams.W_EE*y(1) - wcParams.W_E_SOM*y(2) - wcParams.W_E_PV*y(3) ...
    + wcParams.W_EE_L4*stimParams.eL4 + wcParams.W_EE_L23*stimParams.eL23, ...
    wcParams.theta_E, wcParams.m_E) ) / wcParams.tau_E;

dy(2) = ( -y(2) + threshLinear( ...
    wcParams.W_SOM_E*y(1) - wcParams.W_SOM_SOM*y(2) - wcParams.W_SOM_PV*y(3) ...
    + wcParams.W_SOM_L4*stimParams.eL4 + wcParams.W_SOM_L23*stimParams.eL23, ...
    wcParams.theta_SOM, wcParams.m_SOM) ) / wcParams.tau_I;

dy(3) = ( -y(3) + threshCubic( ...
    wcParams.W_PV_E*y(1) - wcParams.W_PV_SOM*y(2) - wcParams.W_PV_PV*y(3) ...
    + wcParams.W_PV_L4*stimParams.eL4 + wcParams.W_PV_L23*stimParams.eL23, ...
    wcParams.theta_PV, wcParams.m_PV) ) / wcParams.tau_I;

end

function g = threshLinear(x, theta, m)
if x < theta
    g = 0;
elseif x < theta + 1/m
    g = m * (x - theta);
else
    g = 1;
end
end

function g = threshCubic(x, theta, m)
if x < theta
    g = 0;
else
    g = min(1, m * (x - theta)^3);
end
end