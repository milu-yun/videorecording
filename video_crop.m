function video_crop(videoname)
close all; clc; %clearvars; 
vid1=VideoReader(videoname);
videoname = split(videoname,'.');
n=vid1.NumberOfFrames;
frcI = NaN(n,1);

refFrame = 1;
[~,rect] = imcrop(read(vid1,refFrame));

threshold = 50;
resolution = 2;
ccHist = [];
stprod = 0;

for i= 1:n
    im=rgb2gray(read(vid1,i));
    imc=imcrop(im,rect); % The dimention of the new video
   
    imcc = conv2(double(imc),fspecial('Gaussian',[5*resolution 5*resolution],resolution),'valid');
    
    imcThr = double(imextendedmax(imcc,threshold));
    frcI(i) = nanmean(imcThr(:));
    imshow(imcThr);
    if i==1
        unsatisfied = true;
        prompt = ['Define new threshold (Current threshold = ',num2str(threshold),') : '];
        while unsatisfied
            threshold = input(prompt);
            imcThr = double(imextendedmax(imcc,threshold));
            frcI(i) = nanmean(imcThr(:));
            imshow(imcThr);
            fTmp = figure;
            imshow(imc);
            unsatisfied = logical(input('Satisfied ? (0:yes, 1:no) '));
            close(fTmp);
        end
    end


end

save([videoname{1,1},'_crop.mat'],'frcI');
end