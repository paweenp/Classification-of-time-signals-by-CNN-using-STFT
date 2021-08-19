% Train a CNN model with data
function [label, score] = performClassification(model, img)

[label, score] = classify(model,img);

h = figure;
h.Position(3) = 2*h.Position(3);
ax1 = subplot(1,2,1);
ax2 = subplot(1,2,2);
image(ax1,img);

title(ax1,{char(label),num2str(max(score),2)});
[~,idx] = sort(score,'descend');
classes = model.Layers(end).Classes;
classNamesTop = string(classes(idx));
scoreTop = score(idx);
barh(ax2,scoreTop)
xlim(ax2,[0 1])
title(ax2,'Classification')
xlabel(ax2,'Probability')
yticklabels(ax2,classNamesTop)
ax2.YAxisLocation = 'right';

end