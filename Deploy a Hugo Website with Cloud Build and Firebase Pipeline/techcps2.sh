


curl -sL https://firebase.tools | bash



cd ~/my_hugo_site
firebase init


/tmp/hugo && firebase deploy



git config --global user.name "hugo"
git config --global user.email "hugo@blogger.com"



cd ~/my_hugo_site
echo "resources" >> .gitignore



git add .
git commit -m "Add app to Cloud Source Repositories"
git push -u origin master



cd ~/my_hugo_site
cp /tmp/cloudbuild.yaml .


echo -e "options:\n  logging: CLOUD_LOGGING_ONLY" >> cloudbuild.yaml



gcloud alpha builds triggers import --source=/tmp/trigger.yaml


gcloud alpha builds triggers import --source=/tmp/trigger.yaml



cd ~/my_hugo_site



# Edit the file config.toml

sed -i "3c\title = 'Blogging with Hugo and Cloud Build'" config.toml



git add .
git commit -m "I updated the site title"
git push -u origin master



sleep 15



gcloud builds list



gcloud builds log $(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD))



gcloud builds log $(gcloud builds list --format='value(ID)' --filter=$(git rev-parse HEAD)) | grep "Hosting URL"

