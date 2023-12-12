#!/bin/bash
CONF=1_INALT20.L46; CASE=KFS04X; COCA=${CONF}-${CASE}

#1_INALT20.L46-KFS10X_CORE_1M_EUC_boundaries_19580101_19581231.nc
for yy in {1958..2009};do
  CASEn='KFS044' ;  # für die Dateien 1958-1979
  fn=${COCA}_CORE_1Y_EUC_boundaries_${yy}0101_${yy}1231.nc
  fnn=${CONF}-${CASEn}_CORE_1Y_EUC_boundaries_${yy}0101_${yy}1231.nc
  mv ${fn} ${fnn} 
done 

