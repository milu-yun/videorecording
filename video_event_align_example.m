clearvars; clc; close all;
%load file
videodir = dir('*.avi'); %total video number = 6
mousegroup = split(videodir(1).name,'_');
mousegroup = mousegroup{1};
timetype = [1 3 5 10 50 100];
matdir = dir('*.mat');
matlength = length(matdir);
eyeBlink = cell(2,6); %1:abs 2:nor

for jj = 1:6
    for ii = 1: matlength
        if startsWith(matdir(ii).name,[mousegroup, '_',num2str(timetype(jj)),'_'])
            load(matdir(ii).name)
        end
    end
    airTime = eventTime((eventTime(:,1)==3),:);
    frameN = length(timelist);
    frc = zeros(5,360);
    airFrame = zeros(1,5);
    % if timelist not perfect
    if length(timelist)<length(frcI)
        timelistori = timelist;
        timelist = zeros(length(frcI)+1,7);
%         1: made from eventlog
%         for tt1 = 1:length(eventlog)-2
%             frame1 = eventlog(tt1+1).Data.FrameNumber; frame2 = eventlog(tt1+2).Data.FrameNumber;
%             framegap = frame2-frame1;
%             timetemp = linspace(datetime(eventlog(tt1+1).Data.AbsTime),datetime(eventlog(tt1+2).Data.AbsTime),framegap);
%             timegap = datevec(timetemp);
%             timelist(frame1+1:frame2,:) =[(frame1+1:frame2)',timegap];
%         end
        % 2: extend from  timelist
%         for tt2 = 1:frameN-1
%             frame1 = timelistori(tt2,1); frame2 = timelistori(tt2+1,1);
%             framegap = frame2-frame1;
%             timetemp = linspace(datetime(timelistori(tt2,2:7)),datetime(timelistori(tt2+1,2:7)),framegap);
%             timegap = datevec(timetemp);
%             timelist(frame1+1:frame2,:) =[(frame1+1:frame2)',timegap];
%         end
     end
    frameN = length(timelist);
            

    for aa = 1:5
        for kk = 1:frameN-1
            if airTime(aa,2:7)>=timelist(kk,2:7) & airTime(aa,2:7)<=timelist(kk+1,2:7)
                airFrame(aa) = kk;
                frc(aa,:) = frcI(kk-60: kk+299);
            end
        end
    end
    frc = 1-frc;
    %abs frc
    openeye = max(1-frcI);
    absfrc = frc./openeye;
    %normalized by first 2sec frc
    starteye = mean(frc(:,1:60),2);
    starteyeMat = repmat(starteye, 1, 360);
    norfrc = frc./starteyeMat;
    eyeBlink{1,jj} = absfrc;
    eyeBlink{2,jj} = norfrc;
    clear eventTime timelist frcI
end