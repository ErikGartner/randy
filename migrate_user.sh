set -e

OLD_ID=$1
NEW_ID=$2
CONNECTION_STRING=$3
# Assert all arguments are provided
if [ -z "$OLD_ID" ] || [ -z "$NEW_ID" ] || [ -z "$CONNECTION_STRING" ]; then
    echo "Usage: $0 <old_id> <new_id> <connection_string>"
    exit 1
fi

# Test connection to mongo
echo "Testing connection to mongo... Listing lists for $OLD_ID"
docker run -it mongo:7 mongosh $CONNECTION_STRING --eval 'db.lists.find({ author: "'$OLD_ID'" })'

# Confirmation from user
read -p "Are you sure you want to run this command? (y/n) " user_confirmation
if [ "$user_confirmation" != "y" ]; then
    echo "Aborting."
    exit 1
fi
echo "db.lists.updateMany({author: \"$OLD_ID\"}, {\$set: {author: \"$NEW_ID\"}})" | docker run -i mongo:7 mongosh "$CONNECTION_STRING"
echo "db.favorites.updateMany({user: \"$OLD_ID\"}, {\$set: {user: \"$NEW_ID\"}})" | docker run -i mongo:7 mongosh "$CONNECTION_STRING"
