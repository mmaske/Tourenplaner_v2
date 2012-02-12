set i / 
i6
depot
i8
i9
/

set k / 
v2
/;

Scalar m / 
4
/;

Scalar Tmax / 
4000.0
/;

c('i6','i6')= 0;
c('i6','depot')= 21335.0;
c('i6','i8')= 425.0;
c('i6','i9')= 27019.0;
c('depot','i6')= 21101.0;
c('depot','depot')= 0;
c('depot','i8')= 20720.0;
c('depot','i9')= 4609.0;
c('i8','i6')= 425.0;
c('i8','depot')= 21113.0;
c('i8','i8')= 0;
c('i8','i9')= 26797.0;
c('i9','i6')= 25674.0;
c('i9','depot')= 4167.0;
c('i9','i8')= 25293.0;
c('i9','i9')= 0;


t('i6','i6')= 0;
t('i6','depot')= 1482.0;
t('i6','i8')= 64.0;
t('i6','i9')= 1545.0;
t('depot','i6')= 1329.0;
t('depot','depot')= 0;
t('depot','i8')= 1293.0;
t('depot','i9')= 739.0;
t('i8','i6')= 56.0;
t('i8','depot')= 1436.0;
t('i8','i8')= 0;
t('i8','i9')= 1499.0;
t('i9','i6')= 1507.0;
t('i9','depot')= 447.0;
t('i9','i8')= 1471.0;
t('i9','i9')= 0;


Kundenknoten(i) = yes;
Kundenknoten('depot') = no;


parameter cap(k) /
v2 120.0
/;

parameter tf(i) /
i6 0.0
depot 0.0
i8 0.0
i9 0.0
/;

parameter ts(i) /
i6 4000.0
depot 4000.0
i8 4000.0
i9 40000.0
/;

parameter d(i) /
i6 12.0
depot 0
i8 22.0
i9 12.0
/;

