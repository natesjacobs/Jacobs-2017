function createStim (loc_ix)

%creates stimulus values within 5x5 whisker barrel cortex model for each
%stimulus location index in loc_ix
global S

%response decay function
%this decay function was created using matlab's cftool and fit a cross
%section of the ISOI C2 point spread function published in Chen-Bee et al,
%2012, "Whisker array functional representation..."
%assumes 0.5 mm spacing of rat whisker barrels
rd = @(x) 0.2*exp(-0.07*(x*21)) + 0.83*exp(-0.014*(x*21));

for i=loc_ix
    %create subscripts
    [j,k]=ind2sub([5,5],i);
    %distance transform for current stim
    s = zeros(5);
    s(j,k)=1;
    s = bwdist(s);
    %apply response decay function
    s = arrayfun(rd,s);
    %vectorize & save
    S{i}=s(:);
end
