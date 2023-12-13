
# Cloud Run Canary Deployments [GSP1078]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

* In the GCP Console open the Cloud Shell and upload the download file: techcpsgsp1078.sh

```
sudo chmod +x techcpsgsp1078.sh
./techcpsgsp1078.sh
```

# Note: Go to "Cloud build". 
* Do not run the next command until all builts are completed.

```
gcloud beta builds triggers create cloud-source-repositories --trigger-config master-trigger.json

git checkout master
git merge new-feature-1
git push gcp master
```


# Note: Go to "Cloud build". 
* Do not run the next command until all builts are completed.

```
gcloud beta builds triggers create cloud-source-repositories --trigger-config tag-trigger.json

git tag 1.1
git push gcp 1.1
```

# Congratulations, you're all done with the lab 😄

# Thanks for watching :)
