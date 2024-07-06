

EXPORTED_IMAGE="$(gcloud builds submit --tag="${REGION}-docker.pkg.dev/${PROJECT_ID}/$REPO/hello-cloudbuild:${COMMIT_ID}" . | grep IMAGES | awk '{print $2}')"


echo "EXPORTED_IMAGE: ${EXPORTED_IMAGE}"

git checkout dev



sed -i "9c\    args: ['build', '-t', '$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0', '.']" cloudbuild-dev.yaml



sed -i "13c\    args: ['push', '$REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0']" cloudbuild-dev.yaml


sed -i "17s|        image: <todo>|        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild-dev:v1.0|" dev/deployment.yaml




git add .
git commit -m "subscribe to techcps" 
git push -u origin dev



sleep 15


git checkout master


kubectl expose deployment development-deployment -n dev --name=dev-deployment-service --type=LoadBalancer --port 8080 --target-port 8080


sed -i "11c\    args: ['build', '-t', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v1.0', '.']" cloudbuild.yaml


sed -i "16c\    args: ['push', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v1.0']" cloudbuild.yaml


sed -i "17c\        image:  $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v1.0" prod/deployment.yaml



git add .
git commit -m "subscribe to techcps" 
git push -u origin master


sleep 15



kubectl expose deployment production-deployment -n prod --name=prod-deployment-service --type=LoadBalancer --port 8080 --target-port 8080




git checkout dev



sed -i '28a\	http.HandleFunc("/red", redHandler)' main.go


sed -i '32a\
func redHandler(w http.ResponseWriter, r *http.Request) { \
	img := image.NewRGBA(image.Rect(0, 0, 100, 100)) \
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src) \
	w.Header().Set("Content-Type", "image/png") \
	png.Encode(w, img) \
}' main.go



sed -i "9c\    args: ['build', '-t', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild-dev:v2.0', '.']" cloudbuild-dev.yaml


sed -i "13c\    args: ['push', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild-dev:v2.0']" cloudbuild-dev.yaml


sed -i "17c\        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v2.0" dev/deployment.yaml


git add .
git commit -m "subscribe to techcps" 
git push -u origin dev

sleep 15


git checkout master


sed -i '28a\	http.HandleFunc("/red", redHandler)' main.go


sed -i '32a\
func redHandler(w http.ResponseWriter, r *http.Request) { \
	img := image.NewRGBA(image.Rect(0, 0, 100, 100)) \
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{255, 0, 0, 255}}, image.ZP, draw.Src) \
	w.Header().Set("Content-Type", "image/png") \
	png.Encode(w, img) \
}' main.go



sed -i "11c\    args: ['build', '-t', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v2.0', '.']" cloudbuild.yaml


sed -i "16c\    args: ['push', '$REGION-docker.pkg.dev/\$PROJECT_ID/my-repository/hello-cloudbuild:v2.0']" cloudbuild.yaml


sed -i "17c\        image: $REGION-docker.pkg.dev/$PROJECT_ID/my-repository/hello-cloudbuild:v2.0" prod/deployment.yaml


git add .
git commit -m "subscribe to techcps" 
git push -u origin master




kubectl -n prod get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'
kubectl expose deployment production-deployment -n prod --name=prod-deployment-service --type=LoadBalancer --port 8080 --target-port 8080


export DEPLOYMENT="production-deployment"

export NAMESPACE="prod"

export SERVICE_NAME="prod-deployment-service"

export PORT=8080

export TARGET_PORT=8080



#!/bin/bash

# Define function to expose deployment
expose_deployment() {
  kubectl expose deployment $DEPLOYMENT -n $NAMESPACE --name=$SERVICE_NAME --type=LoadBalancer --target-port=$TARGET_PORT --port=$PORT
  return $?
}

# Loop until the expose deployment function succeeds
while ! expose_deployment; do
  echo "Failed and retrying the expose deployment function..."
  sleep 10
done

echo "Successfully exposed the deployment function..."

kubectl -n $NAMESPACE rollout undo deployment/$DEPLOYMENT

if [ $? -eq 0 ]; then
  echo "Successfully rolled back the deployment function..."
else
  echo "Failed and retrying roll back..."
fi



sleep 120

kubectl -n $NAMESPACE rollout undo deployment/$DEPLOYMENT

sleep 60

kubectl -n $NAMESPACE rollout undo deployment/$DEPLOYMENT

sleep 15

cd sample-app
kubectl -n prod rollout undo deployment/production-deployment


