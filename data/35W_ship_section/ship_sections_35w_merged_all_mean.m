%% In and output directories
clear; close all
in_dir = './';

%% sort cruises after dates

mt_sec =[datenum('Oct-90','mmm-YY')
        datenum('Jun-91','mmm-YY')
        datenum('Nov-92','mmm-YY')
        datenum('Feb-93','mmm-YY')
        datenum('Mar-94','mmm-YY')
        datenum('Sep-95','mmm-YY')
        datenum('Apr-96','mmm-YY')
        datenum('Aug-99','mmm-YY')
        datenum('Mar-00','mmm-YY')
        datenum('Nov-00','mmm-YY')
        datenum('Mar-01','mmm-YY')
        datenum('Feb-02','mmm-YY')
        datenum('May-02','mmm-YY')
        datenum('May-03','mmm-YY')
        datenum('Aug-04','mmm-YY')
        datenum('Jun-06','mmm-YY')];
    
file_name ={'m142_35w.mat';
        'm163_35w.mat';
        'm222_35w.mat';
        'cither1_35w.mat';
        'm273_35w.mat';
        'etambot1_35w.mat';
        'etambot2_35w.mat';
        'eq99_35w.mat';
        'm471_35w.mat';
        's152_35w.mat';
        'stc01_35w.mat';
        'stc02_35w.mat';
        'm532_35w.mat';
        's171_35w.mat';
        'm622_35w.mat';
        'm682_35w.mat'};
fN = length(file_name);


%%

mean_data = load([in_dir,'uvmean_EQdeep_35w.mat']);

depth_grid = mean_data.depth_grid;
lat_grid = -6:0.05:9;

s0_array = NaN(length(depth_grid),length(lat_grid),fN);
o_mumolkg_array = NaN(length(depth_grid),length(lat_grid),fN);
s_practical_array = NaN(length(depth_grid),length(lat_grid),fN);
t_insitu_array = NaN(length(depth_grid),length(lat_grid),fN);
u_array = NaN(length(depth_grid),length(lat_grid),fN);
v_array = NaN(length(depth_grid),length(lat_grid),fN);


o_mumolkg_mean = NaN(length(depth_grid),length(lat_grid));
s_practical_mean = NaN(length(depth_grid),length(lat_grid));
s0_mean = NaN(length(depth_grid),length(lat_grid));
t_insitu_mean = NaN(length(depth_grid),length(lat_grid));
u_mean = NaN(length(depth_grid),length(lat_grid));
v_mean = NaN(length(depth_grid),length(lat_grid));

o_mumolkg_std =NaN(length(depth_grid),length(lat_grid));
s_practical_std = NaN(length(depth_grid),length(lat_grid));
s0_std = NaN(length(depth_grid),length(lat_grid));
t_insitu_std = NaN(length(depth_grid),length(lat_grid));
u_std = NaN(length(depth_grid),length(lat_grid));
v_std = NaN(length(depth_grid),length(lat_grid));


%%
for ii = 1:fN;
   data = load([in_dir,file_name{ii}]);
   [zN,yN] = size(data.u_merged);
   yI1 = find(lat_grid==min(data.pos_grid));
   yI2 = find(lat_grid==max(data.pos_grid));
   if exist('data.o2','var')
       o_mumolkg_array(1:zN,yI1:yI2,ii) =data.o2;
   end
   s_practical_array(1:zN,yI1:yI2,ii) =data.s;
   t_insitu_array(1:zN,yI1:yI2,ii) =data.t;
   u_array(1:zN,yI1:yI2,ii) =data.u_merged;
   v_array(1:zN,yI1:yI2,ii) =data.v_merged;
   s0_array(1:zN,yI1:yI2,ii)=data.sth;
end

%%
cruise_list = file_name;

yI1 = find(lat_grid==min(mean_data.pos_grid));
yI2 = find(lat_grid==max(mean_data.pos_grid));

o_mumolkg_mean(:,yI1:yI2) = mean_data.o2_mean;
s_practical_mean(:,yI1:yI2) = mean_data.s_mean;
s0_mean(:,yI1:yI2) = mean_data.sth_mean;
t_insitu_mean(:,yI1:yI2) = mean_data.t_mean;
u_mean(:,yI1:yI2) = mean_data.u_mean;
v_mean(:,yI1:yI2) = mean_data.v_mean;

o_mumolkg_std(:,yI1:yI2) = mean_data.o2_std;
s_practical_std(:,yI1:yI2) = mean_data.s_std;
s0_std(:,yI1:yI2) = mean_data.sth_std;
t_insitu_std(:,yI1:yI2) = mean_data.t_std;
u_std(:,yI1:yI2) = mean_data.u_std;
v_std(:,yI1:yI2) = mean_data.v_std;

clear data fN file_name ii in_dir yN zN mean_data
whos

save('./ship_sections_35w_merged_all_mean.mat')