
# Cloud IAM: Qwik Start [GSP064]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
export USERNAME_2=
```

```
touch sample.txt
gsutil mb gs://$DEVSHELL_PROJECT_ID
gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID
gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID --member="user:$USERNAME_2" --role="roles/viewer"
# please like share & subscribe to Techcps
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member="user:$USERNAME_2" --role="roles/storage.objectViewer"
```

## Congratulations, you're all done with the lab 😄
# Thanks for watching :)
