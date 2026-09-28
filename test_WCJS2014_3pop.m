% Runs the three-population (E, SOM, PV) model for a given L4 drive and
% surround size, and optionally plots the traces and PSD.
%
% Inputs:
%   iEL4        - constant drive to E and PV from L4 (analogous to e0)
%   surroundSize - size of the visual surround (>=1), sets the L2/3 input
%   displayFlag - 1 to plot, 0 to run silently
%
% Outputs:
%   rE, rSOM, rPV   - steady-state firing rates (mean of last 1 second)
%   peakFreq, peakA - peak gamma frequency and amplitude (from r_E)
%   harmonicA       - harmonic amplitude (from r_E)
%   t, y            - full time vector and all three raw traces

function [rE,rSOM,rPV,peakFreq,peakA,harmonicA,t,y] = test_WCJS2014_3pop(iEL4,surroundSize,displayFlag)

if ~exist('displayFlag','var');    displayFlag = 0;    end

[wcParams] = defaultParams_JS3pop;

% Equation 5 from the paper: surround input depends on surroundSize
MIN_iEL23 = 1.4;
m_iEL23   = 0.2;
if surroundSize >= 1
    iEL23 = MIN_iEL23 + (surroundSize - 1) * m_iEL23;
else
    iEL23 = 0;
end

stimParams.eL4  = iEL4;
stimParams.eL23 = iEL23;

tVals = 1:2000;             % 2 seconds, Fs = 1000 Hz
goodTimePos = 1:2000;    % use the last 1 second for measurements
y0 = [0 0 0];   % start from origin: [r_E, r_SOM, r_PV]

odeOpts = odeset('RelTol',1e-8,'AbsTol',1e-10);

[t,y] = ode45(@(t,y) eqn_WCJS2014_3pop(t,y,wcParams,stimParams), tVals, y0, odeOpts);

rE   = mean(y(goodTimePos,1),1);
rSOM = mean(y(goodTimePos,2),1);
rPV  = mean(y(goodTimePos,3),1);

% PSD computed on r_E only, treating it as the LFP-like signal
x   = y(goodTimePos,1);
tMS = tVals(goodTimePos);
gammaRangeHz = [20 30];
[peakFreq,peakA,harmonicA,~,~] = getGammaAndHarmonicProperties(x,gammaRangeHz,10,tMS); % Using PSD file here
harmonicFreq = 2*peakFreq;

if displayFlag
    fftE = fft(y(goodTimePos,1));
    %fftSOM = fft(y(goodTimePos,2));
    %fftPV = fft(y(goodTimePos,3));
    freqVals = 0:numel(fftE)-1; %0:999;

    subplot(211);
    plot(t,y(:,1),'r'); hold on;
    plot(t,y(:,2),'g');
    plot(t,y(:,3),'b');
    legend('E','SOM','PV');
    xlabel('Time (ms)');
    title('Firing rates');

    subplot(212);
    plot(freqVals,log10(abs(fftE)),'r'); hold on;
    %plot(freqVals,log10(abs(fftSOM)),'g');
    %plot(freqVals,log10(abs(fftPV)),'b');
    plot(peakFreq,log10(peakA),'ko');
    plot(harmonicFreq,log10(harmonicA),'mo');
    xlim([0 150]);
    xlabel('Frequency (Hz)');
    title('PSD of LFP(r_E)');
end

end

function wcParams = defaultParams_JS3pop

wcParams.W_EE      = 16;
wcParams.W_E_SOM   = 15;
wcParams.W_E_PV    = 26;

wcParams.W_SOM_E   = 0.25;
wcParams.W_SOM_SOM = 0.025;
wcParams.W_SOM_PV  = 0; %%

wcParams.W_PV_E    = 20;
wcParams.W_PV_SOM  = 1;
wcParams.W_PV_PV   = 1;

wcParams.W_EE_L4   = 0;    % not given in the table; set to 0 for now
wcParams.W_EE_L23  = 0; %%

wcParams.W_SOM_L4  = 0;    % not given in the table; set to 0 for now
wcParams.W_SOM_L23 = 2;

wcParams.W_PV_L4   = 0;    % not given in the table; set to 0 for now
wcParams.W_PV_L23  = 0.5;

wcParams.tau_E     = 20;
wcParams.tau_I     = 10;

wcParams.theta_E   = -11;
wcParams.m_E       = 0.25;

wcParams.theta_SOM = 0.65;
wcParams.m_SOM     = 0;  %%

wcParams.theta_PV  = 13;
wcParams.m_PV      = 0.005;

end