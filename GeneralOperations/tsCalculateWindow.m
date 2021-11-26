function config = tsCalculateWindow(config)

hMax = config.hmax;
%savepath = config.windowMatsDirectory;
windowFct = config.smWindowFunction;

savestr = [savepath '/' ...
    sprintf('%s_hMax_%i.mat', func2str(windowFct), hMax)];

for i = 1:hMax
    windowContainer{i} = config.smWindowFunction(2*i+1);
    config.windowContainer.window{i} = windowContainer{i};
end
config.windowContainer.hMax = config.hmax;

%save(savestr, 'theWindow')
end