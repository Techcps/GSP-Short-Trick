

gcloud auth list

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil mb gs://${PROJECT_ID}
gsutil -m cp gs://cloud-training/gsp895/pcb_images/*.png \
gs://${PROJECT_ID}/demo_pcb_images/

gsutil ls gs://${PROJECT_ID}/demo_pcb_images/*.png > /tmp/demo_pcb_images.csv
gsutil cp /tmp/demo_pcb_images.csv gs://${PROJECT_ID}/demo_pcb_images.csv

