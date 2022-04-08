#!/bin/bash
sed -i s/localhost/$HOSTNAME/g /etc/slurm/slurm.conf
/etc/init.d/postfix start
/etc/init.d/cron start
/etc/init.d/munge start
/etc/init.d/slurmctld start
/etc/init.d/slurmd start

# Fix file permissions
echo "fixing file permissions..."
tmp=$(cat "/home/production/cxgn/sgn/sgn_local.conf" | grep ^tempfiles_base | tr -s ' ' | xargs | cut -d ' ' -f 2)
archive=$(cat "/home/production/cxgn/sgn/sgn_local.conf" | grep ^archive_path | tr -s ' ' | xargs | cut -d ' ' -f 2)
submissions=$(cat "/home/production/cxgn/sgn/sgn_local.conf" | grep ^submission_path | tr -s ' ' | xargs | cut -d ' ' -f 2)
static_content=$(cat "/home/production/cxgn/sgn/sgn_local.conf" | grep ^static_content_path | tr -s ' ' | xargs | cut -d ' ' -f 2)
export="/home/production/export"
export_prod="/home/production/export/prod"
tmp_run="/tmp/cxgn_tools_run"

mkdir -p "$tmp"
chown www-data:www-data "$tmp/../"
mkdir -p "$tmp/mason/obj"; chown -R www-data:www-data "$tmp/mason"
chown -R www-data:www-data "$archive"
chown -R www-data:www-data "$submissions"
mkdir -p "$static_content/folder"; chown -R www-data:www-data "$static_content/folder"
mkdir -p "$export"; chown -R www-data:www-data "$export"; ln -snf "$export" /export
mkdir -p "$export_prod"; chown -R www-data:www-data "$export_prod"
mkdir -p "$tmp_run"; chown www-data:www-data "$tmp_run"
