#!/bin/bash
#SBATCH --job-name=job_extr_hydro_23W0N_CORE
#SBATCH --nodes=20
#SBATCH --tasks-per-node=4
#SBATCH --cpus-per-task=4
#SBATCH --mem=64000
#SBATCH --time=01:00:00
#SBATCH --output=job_extr_hydro_23W0N_CORE.out
#SBATCH --error=job_extr_hydro_23W0N_CORE.err
#SBATCH --partition=base

export OMP_NUM_THREADS=8

#
date; set +x
ncpu=20; ipar=0;

#### latest cdftools
module load gcc12-env/12.3.0
module load nco/5.1.5

TPER=5d
CONF=INALT20.L46; CASE=KFS044; COCA=${CONF}-${CASE}
FDIR="."; # Wind_forcing/data/INALT20_taux_tauy_10S10N/

INPATH=/sfs/fs1/work-geomar1/smomw044/shared/${COCA}-S
SUPPATH=/sfs/fs1/work-geomar1/smomw044/${COCA}

OUTPATH=/gxfs_work/geomar/smomw294/iAtlantic/Subprojects/Wind_forcing/data/INALT20_dynmodes/
regNo='23W0N'
regimin=919
regimax=939 # one more to right which will be drop (interp T on u grid)
regjmin=1619
regjmax=1639

#####################################################################
# define some global attributes as metadata for NetCDF
#
 VAR_PI='Arne Biastoch';
 VAR_PICONTACT='abiastoch@geomar.de';
 VAR_EXPCONF='$CONF';
 VAR_EXPCASE='$CASE';
 VAR_EXPLONG='Subset of hindcast simulation (1958-2019) $COCA ';
 VAR_INSTID='GEOMAR';
 VAR_INSTLONG='GEOMAR Helmholtz Centre for Ocean Research';
 VAR_CONTRIBUTOR='Klaus Getzlaff, \n Franziska schwarzkopf,';
 VAR_CONTRIBCONT='kgetzlaff@geomar.de, \n fschwarzkopf@geomar.de,';
 VAR_CREATORNAME='Kristin Burmeister'
 VAR_CREATORCONT='kristin.burmeister@sams.ac.uk, ORCID 0000-0003-3881-0298'
 VAR_LICENSE='CC-BY4'
 VAR_KEYWORDS='Atlantic, ocean-model, high-resolution, temperature, INALT20'
 VAR_REFERENCE='Schwarzkopf et al., 2019, https://doi.org/10.5194/gmd-12-3329-2019'
 VAR_TOU_1='By using the given data the following terms and conditions will be accepted:\nTo ensure the correct use of model output and to identify and minimize/avoid scientific overlap with GEOMAR or other activities with this model output, we require the following: \n'
 VAR_TOU_2='1. Users of the model output need to inform the GEOMAR modeling group about the planned analysis. Please provide details on the scientific questions, the specific analysis and the required data (model, resolution, output frequency) to the P.I. (if not explicitly named: Arne Biastoch, abiastoch@geomar.de). For further details on the configuration and the data distribution the user will be referred to a scientific modeler of the GEOMAR modeling group. \n'
 VAR_TOU_3='2. Keep the GEOMAR modeling group (main P.I. and/or scientific modeler identified in point 1) updated, in particular if inconsistencies arise that may point to model or data errors. This ensures that we can either clarify the usage of model data or correct/improve the configurations for future experiments. \n'
 VAR_TOU_4='3. Inform the GEOMAR modeling group about any publication that makes use of the model data already at the draft stage. We ensure that the model data have been used accordingly and provide you with references to describe the model configuration, help with specific aspects and provide details of the acknowledgments. Based on the support and involvement, we may ask to appear as co-author(s) of the study. \n'
 VAR_TOU_5='4. Any re-distribution of the data should happen only after approval of the GEOMAR modeling group and involves the consideration of points above. \n'


#####################################################################
# extract mesh_mask file for specified region
#
# ncrcat -O -d x,${regimin},${regimax} -d y,${regjmin},${regjmax} -d z,12,12 ${SUPPATH}/1_mesh_mask.nc  ${OUTPATH}/1_mesh_mask_${regNo}.nc;

#####################################################################
# extract output for specified region

for yy in {1958..2009};do
   for vv in 'grid_T'; do 
     RANDOM_NUM=`echo $RANDOM % 40 + 1 | bc`
     ipar=$[$ipar+1]; sleep 1;
     (bnam=${INPATH}/1_${COCA}_${TPER}_${yy}0101_${yy}1231_${vv}.nc; \
     fnam=${OUTPATH}/1_${COCA}_${TPER}_${yy}0101_${yy}1231_${regNo}_${vv}.nc; \
         ncrcat -O -d x,${regimin},${regimax} -d y,${regjmin},${regjmax} -v vosaline,votemper ${bnam} ${fnam}; \
     ncatted -O -a pi,global,c,c,"${VAR_PI}"  -a pi_email,global,c,c,"${VAR_PICONTACT}"  \
                -a experiment_name,global,c,c,"${VAR_EXPCONF}"  -a experiment_id,global,c,c,"${VAR_EXPCASE}" \
                -a title,global,c,c,"${VAR_EXPLONG}" \
                -a institution_id,global,c,c,"${VAR_INSTID}"  -a institution,global,c,c,"${VAR_INSTLONG}" \
                -a contributor_name,global,c,c,"${VAR_CONTRIBUTOR}"  -a contributor_email,global,c,c,"${VAR_CONTRIBCONT}" \
                -a creator_name,global,c,c,"${VAR_CREATORNAME}"  -a creator_email,global,c,c,"${VAR_CREATORCONT}" \
                -a license,global,c,c,"${VAR_LICENSE}"  -a keywords,global,c,c,"${VAR_KEYWORDS}" -a reference,global,c,c,"${VAR_REFERENCE}" \
                -a terms_of_use,global,c,c,"${VAR_TOU_1}"  -a terms_of_use,global,a,c,"${VAR_TOU_2}"  -a terms_of_use,global,a,c,"${VAR_TOU_3}" \
                -a terms_of_use,global,a,c,"${VAR_TOU_4}"  -a terms_of_use,global,a,c,"${VAR_TOU_5}"  $fnam;)&
     sleep $RANDOM_NUM
     [ $ipar -ge $ncpu ] && wait &&  ipar=0;
   done
done
wait 
