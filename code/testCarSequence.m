clear;

load(fullfile('..','data','carseq.mat')); % variable name = frames. 
[m,n,f] = size(frames);
rects = zeros(f-1,4);

frames_to_print = [1, 100, 200, 300, 400];

current_rect = [60, 117, 146, 152];
width = abs(current_rect(1)-current_rect(3));
height = abs(current_rect(2)-current_rect(4));

for i=1:f-1
    img = frames(:,:,i);
    img_next = frames(:,:,i+1);
    
    imshow(img);
    hold on;
    rectangle('Position',[current_rect(1),current_rect(2),width,height], 'LineWidth',3, 'EdgeColor', 'y');
    hold off;
    pause(0.1);
    
    if any(i==frames_to_print)
        saveas(gcf,sprintf('CarFrame%d.jpg', i));
    end
    
    [u,v] = LucasKanade(img,img_next,current_rect);
	if current_rect(1)+u >= 1 && current_rect(1)+u <= n && ...
        current_rect(2)+v >= 1 && current_rect(2)+v <= m && ...
        current_rect(3)+u >= 1 && current_rect(3)+u <= n && ...
        current_rect(4)+v >= 1 && current_rect(4)+v <= m
        current_rect = round([current_rect(1)+u current_rect(2)+v current_rect(3)+u current_rect(4)+v]);
        rects(i,:) = current_rect;
    end
end

% save the rects
save(fullfile('..','results','carseqrects.mat'),'rects');
