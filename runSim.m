function runSim(noise)

global S W RESULTS

%Runs network simulation for single layer perceptrons (reader neurons) 
%where input vectors are empirically derived spatial patterns of cortical 
%activity.

%Each "trial" consisted of a whisker stimulation input pattern scaled by 
%random stimulus intensity scalar on each trial.

%Each session consisted of a block of nTrials in which 50% use the target 
%stimulus and 50% use a non-target stimulus (CHANCE = SLIGHTLY ABOVE 50%)

%Delta rule used as learning algorithm for updating synaptic weights.

%SETUP
if nargin<1, noise = 0.1; end
nExp=10;
nSessions=40;
nTrials=100;
trialRatio=0.5;
alph = 0.1; %learning constant
p = 0.1; %perturbation

%READER MASKS
%reader 1: 1 input
m{1} = false(5); 
m{1}(3,3) = true;
m{1}=m{1}(:);
%reader 2: 4 contiguous inputs
m{2} = false(5);
m{2}(3:4,3:4) = true;
m{2}=m{2}(:);
%Reader 3: 4 maximally spaced inputs
m{3} = false(5);
m{3}([1 5 13 25]) = true;
m{3}=m{3}(:);
%reader 4: 25 inputs (fully connected)
m{4} = true(25,1);

%RUN SIMULATION
for e = 1:nExp
    createNet;
    for i = 1:nSessions
        %run trials for current session
        for j = 1: nTrials
            
            %pick trial type (target or other)
            t = rand - trialRatio;
            t = t > 0; %true = target, false = other
            
            %get cortical input activity
            s = 13; %target stim
            if t
                %get target stim
                X = S{s};
            else
                %get other stim
                s = 13;
                while s==13
                    s = randi(25,1);
                end
                X = S{s};
            end
            int = rand; %stimulus intensity scalar
            X = X*int; %scale input activity
            X = X + (rand(25,1)-0.5)*2*noise;
            
            %get output activity & train weights
            for k = 1:4
                %output activity
                %weights (vectorize)
                w = W{k}(:);
                %activity (apply mask)
                x = X(m{k});
                %output
                R(k) = (w' * x) > 0;
                %train weights (sessions 1-20)
                if i < nSessions - 19
                    %update weights
                    for l = 1:length(w)
                        dw{k}(l) = alph * (t - R(k)) * x(l); %delta rule
                    end
                    W{k} = W{k} + dw{k}; 
                else
                    %past training window, dw = 0
                    dw{k} = 0; 
                end
            end
            
            %record trial info
            %stimulus
            RESULTS.StimType(i,j,e) = s; %which whisker?
            RESULTS.StimIntensity(i,j,e) = int; %what intensity?
            RESULTS.StimTarget(i,j,e) = t; %target stim (T/F)?
            %output responses
            RESULTS.R1(i,j,e) = R(1);
            RESULTS.R2(i,j,e) = R(2);
            RESULTS.R3(i,j,e) = R(3);
            RESULTS.R4(i,j,e) = R(4);
            %output performance
            RESULTS.R1success(i,j,e) = R(1) == t; %percent correct
            RESULTS.R2success(i,j,e) = R(2) == t;
            RESULTS.R3success(i,j,e) = R(3) == t;
            RESULTS.R4success(i,j,e) = R(4) == t;
            RESULTS.R1dw(i,j,e) = mean(abs(dw{1}(:))); %mean weight changes
            RESULTS.R2dw(i,j,e) = mean(abs(dw{2}(:)));
            RESULTS.R3dw(i,j,e) = mean(abs(dw{3}(:)));
            RESULTS.R4dw(i,j,e) = mean(abs(dw{4}(:)));
            
%             %for state space plots
%             if e==1 && i==1
%                 RESULTS.n1(j)=X(13);
%                 RESULTS.t(j)=t;
%                 RESULTS.n2(j)=X(16);
%             end
            
        end
        %perturb weights
        if i==30
            for k=1:4
                %randomly pick +/- change
                r=rand(1,length(W{k}));
                r(r>=0.5)=1;
                r(r<0.5)=-1;
                W{k} = W{k} .* (r .* p); 
            end
        end
    end
end
            
%save results        
save(['SW noise 0' num2str(noise*10)],'RESULTS');    









