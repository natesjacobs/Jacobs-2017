function createNet

global W

%create synaptic weights (cx > reader)
W{1} = rand(1,1)-0.5;
W{2} = rand(1,4)-0.5;
W{3} = rand(1,4)-0.5;
W{4} = rand(1,25)-0.5;

