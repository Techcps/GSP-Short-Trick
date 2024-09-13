

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID=$DEVSHELL_PROJECT_ID

gcloud services enable cloudbuild.googleapis.com cloudfunctions.googleapis.com run.googleapis.com

sleep 30

gcloud config set project $(gcloud projects list --format='value(PROJECT_ID)' --filter='qwiklabs-gcp')

git clone https://github.com/rosera/pet-theory.git && cd pet-theory/lab08

cat > main.go <<EOF_CP
package main

import (
  "fmt"
  "log"
  "net/http"
  "os"
)

func main() {
  port := os.Getenv("PORT")
  if port == "" {
      port = "8080"
  }
  http.HandleFunc("/v1/", func(w http.ResponseWriter, r *http.Request) {
      fmt.Fprintf(w, "{status: 'running'}")
  })
  log.Println("Pets REST API listening on port", port)
  if err := http.ListenAndServe(":"+port, nil); err != nil {
      log.Fatalf("Error launching Pets REST API server: %v", err)
  }
}
EOF_CP

cat > Dockerfile <<EOF_CP
FROM gcr.io/distroless/base-debian10
WORKDIR /usr/src/app
COPY server .
CMD [ "/usr/src/app/server" ]
EOF_CP



go build -o server


gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.1



gcloud run deploy rest-api \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.1 \
  --platform managed \
  --region=$REGION \
  --allow-unauthenticated \
  --max-instances=2


gcloud firestore databases create --location nam5

wget https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Developing%20a%20REST%20API%20with%20Go%20and%20Cloud%20Run/main.go


go build -o server


gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.2


  
