#!/bin/bash
#--------------Colorised output--------------------------
red=$(tput setaf 1)
grn=$(tput setaf 2)
cya=$(tput setaf 6)
txtbld=$(tput bold)
bldred=${txtbld}$(tput setaf 1)
bldgrn=${txtbld}$(tput setaf 2) 
bldblu=${txtbld}$(tput setaf 4) 
bldcya=${txtbld}$(tput setaf 6) 
txtrst=$(tput sgr0)
#--------------------------------------------------------
clear
mkdir -p ~/out/sepolicy
#-----------------Edit this before use-------------------
LOG_FILE=~/log.txt # Edit your sepolicy log errors file here
#--------------------------------------------------------

#-----------------Permission settings-------------------
permissions_set(){
x_file_perms=(getattr execute execute_no_trans)
r_file_perms=(getattr open read ioctl lock)
w_file_perms=(open append write)
link_file_perms=(getattr link unlink rename)
create_file_perms=(create setattr rw_file_perms link_file_perms)
r_dir_perms=(open getattr read search ioctl)
w_dir_perms=(open search write add_name remove_name)
create_dir_perms=(create reparent rmdir setattr rw_dir_perms link_file_perms)

if [[ " ${x_file_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="rwx_file_perms"
fi
if [[ " ${r_file_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="rwx_file_perms"
fi
if [[ " ${w_file_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="rwx_file_perms"
fi
if [[ " ${link_file_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="link_file_perms"
fi
if [[ " ${create_file_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="create_file_perms"
fi
if [[ " ${r_dir_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="rw_dir_perms"
fi
if [[ " ${w_dir_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="rw_dir_perms"
fi
if [[ " ${create_dir_perms[@]} " =~ "$SERVICE_PERM" ]]; then
    SERVICE_PERM_ARR="create_dir_perms"
fi
}
#--------------------------------------------------------

#--------------Getting attributes from log file--------------------------
while read LINE; do
read SERVICE_NAME < <(echo $LINE | grep -o "I [a-z,0-9,_, ]* : " | grep -o "[a-z0-9]*")
read SERVICE_PERM < <(echo $LINE | grep -o "{ [a-z_]* }" | grep -o "[a-z_]*")
read SERVICE_TYPE_CHECK < <(echo $LINE | grep -o "object_r:[a-z_]*:" | grep -o ":[a-z_]*:" | grep -o "[a-z]*")
read SERVICE_TYPE2 < <(echo $LINE | grep -o "tclass=[a-z_]* " | grep -o "=[a-z_]*" | grep -o "[a-z_]*")
#------------------------------------------------------------------------

#-----------------Check for empty variables------------------------------
if [ -z "$SERVICE_TYPE_CHECK" ]
then
  echo "${txtbld}${bldcya}Some types in ${txtbld}${bldblu}$SERVICE_NAME${txtrst}${bldcya} are ${bldred}EMPTY${txtrst}${bldcya}, please check it manualy.${txtrst}"
else
  read SERVICE_TYPE < <(echo $LINE | grep -o "object_r:[a-z_]*:" | grep -o ":[a-z_]*:" | grep -o "[a-z]*")
fi 
#------------------------------------------------------------------------

#-----------------Write collected data to *.te files---------------------
permissions_set
echo "allow $SERVICE_NAME $SERVICE_TYPE:$SERVICE_TYPE2 { $SERVICE_PERM_ARR };" >> ~/out/"$SERVICE_NAME"non_cleaned.te
sort -u ~/out/"$SERVICE_NAME"non_cleaned.te > ~/out/sepolicy/$SERVICE_NAME.te
done < $LOG_FILE
rm -rf ~/out/*.te
#------------------------------------------------------------------------
