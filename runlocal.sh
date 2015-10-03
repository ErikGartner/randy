cd app

echo "Setting development packages"
meteor add accounts-password
meteor remove accounts-facebook
meteor add msavin:mongol

echo "Starting server"
meteor run --settings settings.json
