
# Dataproc: Qwik Start - Command Line [GSP104]


* Click Activate Cloud Shell Activate Cloud Shell icon at the top of the Google Cloud console.

```
gcloud auth list
gcloud config list project
gcloud config set dataproc/region us-east1
gcloud dataproc clusters create example-cluster --worker-boot-disk-size 500
gcloud dataproc jobs submit spark --cluster example-cluster \
  --class org.apache.spark.examples.SparkPi \
  --jars file:///usr/lib/spark/examples/jars/spark-examples.jar -- 1000
```

## Congratulations, you're all done with the lab 😄
## If you consider that the video helped you to complete your lab, so please do like and subscribe
## Thanks for watching :)




