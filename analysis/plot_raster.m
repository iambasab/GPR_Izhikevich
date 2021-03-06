gpi = csvread ('/home/seb/src/SpineML_2_BRAHMS/temp/log/GPi_spike_log.csv');

% Separate into channels
gpi1 = gpi(gpi(:,2)<20,:);
gpi2 = gpi(gpi(:,2)>=20 & gpi(:,2)<40,:);
gpi3 = gpi(gpi(:,2)>=40,:);

% Bin into 20 bins
[h1,i1] = hist (gpi1(:,1),20);
[h2,i2] = hist (gpi2(:,1),20);
[h3,i3] = hist (gpi3(:,1),20);

% Find range
i1r = max(i1)-min(i1);
i2r = max(i2)-min(i2);
i3r = max(i3)-min(i3);

h1s = 1000.*h1./i1r;
h2s = 1000.*h2./i2r;
h3s = 1000.*h3./i3r;

figure(1);
clf;
ch1 = plot (i1,h1s, 'og-');
hold on;
ch2 = plot (i2,h2s, 'or-');
ch3 = plot (i3,h3s, 'ob-');

xlabel('Simulation time (ms)')
ylabel('Mean channel firing rate (sp/s)')

legend ('Ch 1','Ch 2','Ch 3','location','southwest')
