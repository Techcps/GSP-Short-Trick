

docker run -d --name $CONTAINER_NAME -p 9000:8602 -p 3006:8603 $CONTAINER_REGISTRY

docker container ls

gsutil cp gs://cloud-training/gsp895/prediction_script.py .

gsutil mb gs://${DEVSHELL_PROJECT_ID}

gsutil -m cp gs://cloud-training/gsp897/cosmetic-test-data/*.png \
gs://${DEVSHELL_PROJECT_ID}/cosmetic-test-data/
gsutil cp gs://${DEVSHELL_PROJECT_ID}/cosmetic-test-data/IMG_07703.png .

python3 ./prediction_script.py --input_image_file=./IMG_07703.png  --port=8602 --output_result_file=$DEFECTIVE_NAME

gsutil cp gs://${DEVSHELL_PROJECT_ID}/cosmetic-test-data/IMG_0769.png .

python3 ./prediction_script.py --input_image_file=./IMG_0769.png  --port=8602 --output_result_file=$NON_DEFECTIVE_NAME

