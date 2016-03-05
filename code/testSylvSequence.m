clear;

load(fullfile('..','data','sylvseq.mat'));
load(fullfile('..','data','sylvbases.mat'));

[m,n,f] = size(frames);
rects = zeros(f-1,4);

current_rect = [102, 62, 156, 108];
current_rect_basis = [102, 62, 156, 108];
width = abs(current_rect(1)-current_rect(3));
height = abs(current_rect(2)-current_rect(4));

for i=1:f-1
    img = frames(:,:,i);
    img_next = frames(:,:,i+1);
    imshow(img);
    hold on;
    rectangle('Position',[current_rect(1),current_rect(2),width,height], 'LineWidth',3, 'EdgeColor', 'g');
    rectangle('Position',[current_rect_basis(1),current_rect_basis(2),width,height], 'LineWidth',3, 'EdgeColor', 'y');
    hold off;
    pause(0.01);
    frames_to_print = [1, 200, 300, 350, 400];
    if any(i==frames_to_print)
        saveas(gcf,sprintf('SylvFrame%d.jpg', i));
    end

    [u,v] = LucasKanade(img,img_next,current_rect);
    current_rect = round([current_rect(1)+u current_rect(2)+v current_rect(3)+u current_rect(4)+v]);

    [u,v] = LucasKanadeBasis(img,img_next,current_rect_basis, bases);
    current_rect_basis = round([current_rect_basis(1)+u current_rect_basis(2)+v current_rect_basis(3)+u current_rect_basis(4)+v]);
    rects(i,:) = current_rect_basis;
end

save(fullfile('..','results','sylvseqrects.mat'), 'rects');
