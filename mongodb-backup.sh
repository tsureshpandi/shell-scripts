#!/bin/bash

#
# You have to change these following settings.
#
HOST=your_mongo_host:port
DB=db_name
USER=user_name
PASS=user_password

OUTPUT_FILE=$DB-`date +\%Y-\%a`-BK.zip
COLLECTIONS=`mongo "$HOST/$DB" -u $USER -p $PASS --quiet --eval "rs.slaveOk();db.getCollectionNames();" | sed 's/,/ /g'`

for collection in $COLLECTIONS; do
	echo "Exporting $DB/$collection"
	mongodump -h $HOST -d $DB -c $collection -u $USER -p $PASS
done

echo "Dump completed."

# If need zip file
cd dump/$DB/
zip -r $OUTPUT_FILE ./
