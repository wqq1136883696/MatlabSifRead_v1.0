% figure(1)
% load('beipin.mat');
% x = beiping(:,1) ./ 180 .* pi;
% polarscatter(x,beiping(:,2),'filled');
% title("WSe2 Multiplier Signal");

figure(2)
load('beiping_WSe2_max.mat');
load('beiping_Mo.mat');
% x = beiping_WSe2_max(:,1) ./ 180 .* pi;
scatter(beiping_WSe2_max(:,1),beiping_WSe2_max(:,2),'filled');hold on;
scatter(beiping_Mo(:,1),beiping_Mo(:,2)+120);
hold off;
% plot(beiping_WSe2_max(:,1),beiping_WSe2_max(:,2));
title("Multiplier Signal");
ylim([600 900]);
xlabel("angle");
ylabel("count");
grid on;
box on;
legend({'WSe2','MoTe2'});
legend('boxoff');
