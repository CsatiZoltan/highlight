function wholeAxesCovered
% Test functionality when there is no free area on the axes

figure; % do not plot into a possibly existing figure
patch([0 1 1 0], [0 0 1 1], [0 0 1]); % cover the whole axes
highlight;

end