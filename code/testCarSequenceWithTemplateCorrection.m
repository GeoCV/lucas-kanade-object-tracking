clear;

load(fullfile('..','data','carseq.mat')); % variable name = frames. 
[m,n,f] = size(frames);
rects = zeros(f-1,4);

frames_to_print = [1, 100, 200, 300, 400];
frames_to_correct = 1:50:400;

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
        saveas(gcf,sprintf('yCarFrame%d.jpg', i));
    end
    
    if any(i==frames_to_correct)
        mask = SubtractDominantMotion(img, img_next);
        max_score = 0;
        for x=0+(-5:5)
            for y=0+(-5:5)
                if current_rect(1)+x >= 1 && current_rect(1)+x <= n && ...
                    current_rect(2)+y >= 1 && current_rect(2)+y <= m && ...
                    current_rect(3)+x >= 1 && current_rect(3)+x <= n && ...
                    current_rect(4)+y >= 1 && current_rect(4)+y <= m
                    mask_rect_indices = round([current_rect(1)+x current_rect(2)+y current_rect(3)+x current_rect(4)+y]);
                    mask_rect = mask(mask_rect_indices(2):mask_rect_indices(4), mask_rect_indices(1):mask_rect_indices(3));
                    score = sum(sum(mask_rect));
                    if score > max_score + 100
                        max_score = score;
                        current_rect = mask_rect_indices;
                    end
                end
            end
        end
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

save(fullfile('..','results','carseqrects-wcrt.mat'), 'rects');

