

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
gcloud config set project $DEVSHELL_PROJECT_ID

gcloud config set compute/region $REGION


gcloud services enable container.googleapis.com cloudbuild.googleapis.com sourcerepo.googleapis.com containeranalysis.googleapis.com --project=$DEVSHELL_PROJECT_ID

sleep 10


gcloud artifacts repositories create my-repository --project=$DEVSHELL_PROJECT_ID --repository-format=docker --location=$REGION

gcloud container clusters create hello-cloudbuild --project=$DEVSHELL_PROJECT_ID --region $REGION --num-nodes 1


git config --global user.email "$USER_EMAIL"

git config --global user.name "techcps"

gcloud source repos create hello-cloudbuild-app

gcloud source repos create hello-cloudbuild-env

cd ~

git clone https://github.com/GoogleCloudPlatform/gke-gitops-tutorial-cloudbuild hello-cloudbuild-app

cd ~/hello-cloudbuild-app

sed -i "s/us-central1/$REGION/g" cloudbuild.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-delivery.yaml
sed -i "s/us-central1/$REGION/g" cloudbuild-trigger-cd.yaml
sed -i "s/us-central1/$REGION/g" kubernetes.yaml.tpl

export PROJECT_ID=$(gcloud config get-value project)

git remote add google "https://source.developers.google.com/p/${PROJECT_ID}/r/hello-cloudbuild-app"

cd ~/hello-cloudbuild-app


COMMIT_ID="$(git rev-parse --short=7 HEAD)"
gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/my-repository/hello-cloudbuild:${COMMIT_ID}" .


gcloud builds triggers create cloud-source-repositories --project=$PROJECT_ID --name="hello-cloudbuild" --description="subscribe to techcps" --service-account="projects/$PROJECT_ID/serviceAccounts/$PROJECT_ID@$PROJECT_ID.iam.gserviceaccount.com" --repo="hello-cloudbuild-app" --branch-pattern="^master$" --build-config="cloudbuild.yaml"

cd ~/hello-cloudbuild-app

git add .

git commit -m "Type Any Commit Message here"

git push google master

PROJECT_NUMBER="$(gcloud projects describe ${PROJECT_ID} --format='get(projectNumber)')"

gcloud projects add-iam-policy-binding ${PROJECT_NUMBER} \
--member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
--role=roles/container.developer

cd ~

gcloud source repos clone hello-cloudbuild-env

cd ~/hello-cloudbuild-env

git checkout -b production

cd ~/hello-cloudbuild-env

cp ~/hello-cloudbuild-app/cloudbuild-delivery.yaml ~/hello-cloudbuild-env/cloudbuild.yaml

git add .

git commit -m "Create cloudbuild.yaml for deployment"

git checkout -b candidate

git push origin production

git push origin candidate


PROJECT_NUMBER="$(gcloud projects describe ${PROJECT_ID} \
--format='get(projectNumber)')"
cat >/tmp/hello-cloudbuild-env-policy.yaml <<EOF_CP
bindings:
- members:
  - serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com
  role: roles/source.writer
EOF_CP


gcloud source repos set-iam-policy \
hello-cloudbuild-env /tmp/hello-cloudbuild-env-policy.yaml


gcloud builds triggers create cloud-source-repositories --project=$PROJECT_ID --name="hello-cloudbuild-deploy" --description="subscribe to techcps" --service-account="projects/$PROJECT_ID/serviceAccounts/$PROJECT_ID@$PROJECT_ID.iam.gserviceaccount.com" --repo="hello-cloudbuild-env" --branch-pattern="^candidate$" --build-config="cloudbuild.yaml"


cd ~/hello-cloudbuild-app

cp cloudbuild-trigger-cd.yaml cloudbuild.yaml

cd ~/hello-cloudbuild-app

git add cloudbuild.yaml

git commit -m "Trigger CD pipeline"

git push google master


echo "Congratulations, you're all done with the lab"
echo "Please like share and subscribe to techcps(https://www.youtube.com/@techcps)..."


