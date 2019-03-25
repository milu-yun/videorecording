function timerecord(obj,event)
persistent timelist
%pTime = clock;
EventData = event.Data;
pTime = EventData.AbsTime;
pFrame = obj.FramesAcquired;

timelist = [timelist;  pFrame, pTime];
if ~isrunning(obj)
    handles.fileName = [obj.Tag, '_frametime.mat'];
    save(handles.fileName, 'timelist')
    timelist = [];
end
end
