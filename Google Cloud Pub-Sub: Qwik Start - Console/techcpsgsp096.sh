
gcloud auth list
gcloud config list project

gcloud services enable pubsub.googleapis.com

gcloud pubsub topics create MyTopic

gcloud pubsub subscriptions create MySub --topic=MyTopic
