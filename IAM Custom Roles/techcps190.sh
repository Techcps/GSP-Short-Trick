


gcloud config set compute/region $REGION

# gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID


cat > role-definition.yaml <<EOF_CP
title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
EOF_CP


gcloud iam roles create editor --project $DEVSHELL_PROJECT_ID \
--file role-definition.yaml



gcloud iam roles create viewer --project $DEVSHELL_PROJECT_ID \
--title "Role Viewer" --description "Custom role description." \
--permissions compute.instances.get,compute.instances.list --stage ALPHA



cat > new-role-definition.yaml <<EOF_CP
description: Edit access for App Versions
etag: 
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
- storage.buckets.get
- storage.buckets.list
name: projects/$DEVSHELL_PROJECT_ID/roles/editor
stage: ALPHA
title: Role Editor
EOF_CP



gcloud iam roles update editor --project $DEVSHELL_PROJECT_ID \
--file new-role-definition.yaml --quiet



gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--add-permissions storage.buckets.get,storage.buckets.list


gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--stage DISABLED


gcloud iam roles delete viewer --project $DEVSHELL_PROJECT_ID



gcloud iam roles undelete viewer --project $DEVSHELL_PROJECT_ID



