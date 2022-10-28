#! /usr/bin/env bash

faketty () {
    script -qefc "$(printf "%q " "$@")" /dev/null
}

rm -f /ready
echo "==> SETTING UP TEST DATABASES"

fixture_path="/home/production/cxgn/sgn/t/data/fixture/cxgn_fixture.sql";
db_patch_bin="/home/production/cxgn/sgn/db/run_all_patches.pl"
DB_NAME="breedbase_test_template"
DB_USER=$(cat /home/production/cxgn/sgn/sgn_test.conf | grep dbuser | tr -s ' ' | cut -d ' ' -f 2)
DB_PASS=$(cat /home/production/cxgn/sgn/sgn_test.conf | grep dbpass | tr -s ' ' | cut -d ' ' -f 2)

echo "... creating .pgpass file"
echo "$DB_HOST:$DB_PORT:*:postgres:$PGPASSWORD" > $HOME/.pgpass
echo "$DB_HOST:$DB_PORT:*:$DB_USER:$DB_PASS" >> $HOME/.pgpass
chmod 600 $HOME/.pgpass

echo "... creating new database"
psql -h "$DB_HOST" -U postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"
createdb -h $DB_HOST -U postgres -T template0 -E UTF8 --no-password $DB_NAME

echo "... adding web_usr"
psql -h $DB_HOST -U postgres $DB_NAME -c "CREATE USER web_usr PASSWORD '$DB_PASS'"

echo "... loading fixture"
cat "$fixture_path" | psql -h $DB_HOST -U postgres $DB_NAME > /dev/null

echo "... running database patches"
faketty perl $db_patch_bin -u postgres -p $PGPASSWORD -h $DB_HOST -d $DB_NAME -e janedoe

if [ ! -z "$DB_UNIT" ]; then
    echo "... creating unit database"
    psql -h "$DB_HOST" -U postgres -c "DROP DATABASE IF EXISTS $DB_UNIT;"
    psql -h "$DB_HOST" -U postgres -c "CREATE DATABASE $DB_UNIT WITH TEMPLATE $DB_NAME;"
fi

if [ ! -z "$DB_FIXTURE" ]; then
    echo "... creating fixture database"
    psql -h "$DB_HOST" -U postgres -c "DROP DATABASE IF EXISTS $DB_FIXTURE;"
    psql -h "$DB_HOST" -U postgres -c "CREATE DATABASE $DB_FIXTURE WITH TEMPLATE $DB_NAME;"
fi

if [ ! -z "$DB_MECH" ]; then
    echo "... creating mech database"
    psql -h "$DB_HOST" -U postgres -c "DROP DATABASE IF EXISTS $DB_MECH;"
    psql -h "$DB_HOST" -U postgres -c "CREATE DATABASE $DB_MECH WITH TEMPLATE $DB_NAME;"
fi

if [ ! -z "$DB_SELENIUM" ]; then
    echo "... creating selenium database"
    psql -h "$DB_HOST" -U postgres -c "DROP DATABASE IF EXISTS $DB_SELENIUM;"
    psql -h "$DB_HOST" -U postgres -c "CREATE DATABASE $DB_SELENIUM WITH TEMPLATE $DB_NAME;"
fi

touch /ready
echo "==> DONE"

# keep the container running so it shows as healthy...
tail -f /dev/null
