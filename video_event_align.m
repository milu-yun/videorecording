function video_event_align(videoname)
% input must be a 'char'(one file name) or 'cell'(list of files name)
% include file format(ex.'avi')
validateattributes(videoname, {'char','cell'},{'nonempty'})
if class(videoname) =='char'
    videoname = {videoname};
end
videoN = length(videoname);
eyeBlink = cell(2,videoN); %1:abs 2:nor
for vv = 1:videoN
    %load file
    nameinfo = split(videoname{vv},'_');
    mousegroup = [nameinfo{1} '_' nameinfo{2} '_' nameinfo{3}]; %mouseline, genotype, mousenumber
    timetype = [nameinfo{4}]; % date
    matdir = dir('*.mat');
    matlength = length(matdir);
    eyeBlink = cell(2,videoN); %1:abs 2:nor
    
    
    for ii = 1: matlength
        if startsWith(matdir(ii).name,[mousegroup, '_',timetype,'_'])
            load(matdir(ii).name)
        end
    end
    cueTime = eventTime((eventTime(:,1)==1),:); %cue onset time
    airTime = eventTime((eventTime(:,1)==3),:); %airpuff onset time
    frameN = length(timelist);
    frc = zeros(length(cueTime),360); %-2~10 s
    airFrame = zeros(1,length(cueTime));
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
        %         2: extend from timelist
                for tt2 = 1:frameN-1
                    frame1 = timelistori(tt2,1); frame2 = timelistori(tt2+1,1);
                    framegap = frame2-frame1;
                    timetemp = linspace(datetime(timelistori(tt2,2:7)),datetime(timelistori(tt2+1,2:7)),framegap);
                    timegap = datevec(timetemp);
                    timelist(frame1+1:frame2,:) =[(frame1+1:frame2)',timegap];
                end
        %         3: total duration & & frame number
%          vid1=VideoReader(videoname{vv});
%          totDuration= vid1.Duration;
%          orivideoframe = eventlog(end-1).Data.FrameNumber;
%          timelist(orivideoframe,:) = [orivideoframe, eventlog(end-1).Data.AbsTime];
%          for tt3 = 1:orivideoframe-1
%              timelist(orivideoframe-tt3,:) = ...
%                  [orivideoframe-tt3, datevec(datetime(timelist(orivideoframe-tt3+1,2:7))-seconds(1/30))];
%          end  
    end
    frameN = length(timelist);    
    
    for aa = 1:size(airTime,1)
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
    eyeBlink{1,vv} = absfrc;
    eyeBlink{2,vv} = norfrc;
    clear eventTime timelist frcI    
    
end
save([nameinfo{1} '_' nameinfo{2} '_' nameinfo{3} '_' nameinfo{4} '_eventalign.mat'],'eyeBlink');
end