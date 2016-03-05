load(fullfile('..','data','aerialseq.mat'));

[m,n,f] = size(frames);
rects = zeros(m,n,f-1);

for i=1:f-1
    img = frames(:,:,i);
    img_next = frames(:,:,i+1);
    mask = SubtractDominantMotion(img,img_next);
    rects(:,:,i) = mask(:,:);
    mask_color(:,:,1) = zeros(size(mask(:,:,1)));
    mask_color(:,:,2) = mask(:,:)*255;
    mask_color(:,:,3) = zeros(size(mask(:,:,1)));
    
    %imshow(img);
    %hold on;
    %[blobX, blobY] = find(mask);
    %plot(blobY, blobX, 'go', 'MarkerFaceColor', 'green');
    %hold off;
    
    fused_image = imfuse(img, mask_color, 'blend', 'Scaling', 'joint');
    imshow(fused_image);
    
    pause(0.01);
    frames_to_print = [30, 60, 90, 120];
    if any(i==frames_to_print)
        saveas(gcf,sprintf('AerialFrame%d.jpg', i));
    end
end

save(fullfile('..','results','aerialseqrects.mat'),'rects');
