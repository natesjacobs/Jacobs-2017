function init

%global variables
% W: synaptic weights
% S: stimuli / cortical inputs
% RESULTS: trial info and performance stats

global S W RESULTS

%% setup
%create stims
createStim(1:25);

%% run simulations
%runSim(noise);
%runSimMW;

%robustness to noise
for noise= [0 0.1 0.2 0.3]
    runSim(noise)
    runPlots;
    %save as EPS
    saveas(gcf,['SW noise 0' num2str(noise*10)],'epsc');
end

%robustness to complex code
targets{1} = [13 14];
targets{2} = [13 21];
for i=1:length(targets)
    runSimMW(targets{i});
    runPlots;
    %save as EPS
    saveas(gcf,['MW whiskers ' num2str(targets{i})],'epsc');
end


%% plots
    function runPlots
        close all;
        %performance (%correct)
        r1=mean(RESULTS.R1success,2);
        r2=mean(RESULTS.R2success,2);
        r3=mean(RESULTS.R3success,2);
        r4=mean(RESULTS.R4success,2);
        %experiment means & sem
        r1m=mean(r1,3);
        r2m=mean(r2,3);
        r3m=mean(r3,3);
        r4m=mean(r4,3);
        r1s=std(r1,[],3)/sqrt(100);
        r2s=std(r2,[],3)/sqrt(100);
        r3s=std(r3,[],3)/sqrt(100);
        r4s=std(r4,[],3)/sqrt(100);
        %plots
        errorbar(1:40,r1m,r1s,'Marker','o','LineStyle','none','Color',[0.5 0.5 0.5]);
        hold on;
        errorbar(1:40,r2m,r2s,'Marker','o','LineStyle','none','Color','r');
        errorbar(1:40,r3m,r3s,'Marker','o','LineStyle','none','Color','b');
        errorbar(1:40,r4m,r4s,'Marker','o','LineStyle','none','Color','g');
    end
end

% %plot linearly separable
% n1a = RESULTS.n1(RESULTS.t);
% n1b = RESULTS.n1(~RESULTS.t);
% n2a = RESULTS.n2(RESULTS.t);
% n2b = RESULTS.n2(~RESULTS.t);
% %1 dimension
% scatter(ones(1,length(n1a)),n1a);
% hold on;
% scatter(ones(1,length(n1b)),n1b);
% %2 dimensions
% scatter(n1a,n2a);
% hold on;
% scatter(n1b,n2b);





