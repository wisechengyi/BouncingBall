imshow(contour);% close all;
close all;

CHECKTIME = 0.001;
RADIUS = 10;
BallPosition = [100;100];
v = [15;15];

DlgH = figure;
H = uicontrol('Style', 'PushButton', ...
    'String', 'Break', ...
    'Callback', 'delete(gcbf)');
% while (ishandle(H))
%     disp(clock);
%     pause(0.5);
% end

aviobj = avifile('bounce.avi','compression','None');

vid = videoinput('macvideo');
set(vid, 'ReturnedColorSpace', 'RGB');
triggerconfig(vid, 'manual');
start(vid);
% [height,width] = size(background);

prev = getsnapshot(vid);
prev = flipdim(prev,2);
lastValidContour =zeros(size( prev(:,:,1)));


% ddd =0;
% while (ddd<300)
while (ishandle(H))
    ddd=ddd+1;
    %     get coutour
    %     img = getNormalizedGreyScaleImageFromWebCam(vid);
    
    img = getsnapshot(vid);
    img = flipdim(img,2);
    %     diff = abs(img-background);
    diff = prev-img;
    grayDiff = rgb2gray(diff);
    diffStd = std2(grayDiff);
    if diffStd>5
        prev = img;
        BWdiff = im2bw(diff,graythresh(diff));
        contour = bwareaopen(BWdiff,20);
        lastValidContour = contour;
    else
        contour = lastValidContour;
    end
    
%     imshow(contour);
    
    
    contourGradient = gradient(double(contour));
    
    v1 = getVelocity(contour,BallPosition,v);

    
    if (~ isequal(v1,v))
        BallPosition= BallPosition+3*v1;
    else
        BallPosition= BallPosition+v1;
    end
    
   v=v1;
   v = boundV(BallPosition,v, size(contour));
   
    
   contourWithBall = MidpointCircle( contour, RADIUS, BallPosition(2), BallPosition(1) , 1);
   layer1 = MidpointCircle(img(:,:,1), RADIUS, BallPosition(2), BallPosition(1) , 255);
   layer2 = MidpointCircle(img(:,:,2), RADIUS, BallPosition(2), BallPosition(1) , 0);
   layer3 = MidpointCircle(img(:,:,3), RADIUS, BallPosition(2), BallPosition(1) , 0);
   imageWithBalls(:,:,1) = layer1;
   imageWithBalls(:,:,2) = layer2;
   imageWithBalls(:,:,3) = layer3;
   %     contourWithBall = MidpointCircle( rgb2gray(img), RADIUS, BallPosition(1), BallPosition(2) , 1);
   %   imshow(contourWithBall);
   
   subplot(1,2,1), imshow(imageWithBalls)
   subplot(1,2,2), imshow(contourWithBall)
%    
%    imshow(imageWithBalls);
   
   
%    subplot(1,3,3), imshow(contour)
    %%procedure to mask the original image
%     mask = uint8(contour);
%     maskedImg = zeros(size(img));
%     maskedImg(:,:,1)=  img(:,:,1) .* mask;
%     maskedImg(:,:,2)=   img(:,:,2) .* mask;
%     maskedImg(:,:,3)=   img(:,:,3) .* mask;
%     maskedImg = uint8(maskedImg);\
%     imshow(maskedImg);
      %%

    pause(CHECKTIME);
    
        %%add to video
%     F=getframe(DlgH);
%     aviobj = addframe(aviobj,F);

end
stop(vid);
aviobj = close(aviobj);
