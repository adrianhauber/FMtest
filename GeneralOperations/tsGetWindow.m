function theWindow = tsGetWindow(h, config)

% hMax = config.hmax;
% windowFct = config.smWindowFunction; 
% savepath = config.windowMatsDirectory;

% savestr = [savepath '/' ...
%     sprintf('%s_hMax_%i.mat', func2str(windowFct), hMax)];

x = config.windowContainer.window;
if ~isempty(x{h})
    theWindow = x{h};
else
    theWindow = bartlett(2*h+1);
    warning('Recalculated window')
    disp(h)
end