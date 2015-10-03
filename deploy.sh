cd app

echo "Did you update randy-version?"

echo "Setting packages"
meteor add accounts-facebook
meteor remove accounts-password
meteor remove insecure
meteor remove autopublish
meteor remove msavin:mongol

echo "Deploying to Meteor servers"
meteor deploy --settings settings.json randy.xeed.me
