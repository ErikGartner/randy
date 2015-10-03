cd app

echo "Did you update randy-version?"

echo "Setting packages"
meteor add accounts-facebook
meteor remove accounts-password
meteor remove insecure
meteor remove autopublish

echo "Deploying to Meteor servers"
meteor deploy --settings settings.json xeed.randy.me
