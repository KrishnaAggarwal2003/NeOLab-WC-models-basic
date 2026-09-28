clear;

iEL4 = 0:1:20; lE=length(iEL4);
surroundSize = 0:4:4; lI=length(surroundSize);
displayFlag = 1;

rE = zeros(lE,lI);
rSOM = zeros(lE,lI);
rPV = zeros(lE,lI);
peakA = zeros(lE,lI);
peakFreq = zeros(lE,lI);
harmonicA = zeros(lE,lI);
%t = zeros(lE,lI);
%y = zeros(lE,lI);

for j=1:lE
    for k=1:lI
        disp([j k]);
        [rE(j,k),rSOM(j,k),rPV(j,k),peakFreq(j,k),peakA(j,k),harmonicA(j,k)] = test_WCJS2014_3pop(iEL4(j),surroundSize(k),displayFlag);
        %[eFR(j,k),iFR(j,k),peakA(j,k),peakFreq(j,k),harmonicA(j,k)] = test_WCJS2014(e0(j),i0(k),0);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colormap jet

subplot(321)
pcolor(iEL4,surroundSize,rE'); shading interp; 
xlabel('iE'); ylabel('iI'); colorbar;
title('E firing rate');

subplot(322)
pcolor(iEL4,surroundSize,rE'); shading interp;
xlabel('iE'); ylabel('iI'); colorbar;
title('i Firing rate');

subplot(323)
pcolor(iEL4,surroundSize,peakA'); shading interp;
xlabel('iE'); ylabel('iI'); colorbar;
title('Peak Amplitude');

subplot(324)
pcolor(iEL4,surroundSize,peakFreq'); shading interp;
xlabel('iE'); ylabel('iI'); colorbar;
title('Peak Frequency (Hz)');

subplot(325)
pcolor(iEL4,surroundSize,harmonicA'); shading interp;
xlabel('iE'); ylabel('iI'); colorbar;
title('Harmonic Amplitude');

subplot(326)
powerRatio = (harmonicA' ./peakA');
powerRatio(peakA'<2)=0;
pcolor(iEL4,surroundSize,powerRatio); shading interp;
xlabel('iE'); ylabel('iI'); colorbar;
title('Amplitude Ratio');