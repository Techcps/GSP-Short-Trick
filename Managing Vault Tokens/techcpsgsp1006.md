
# Managing Vault Tokens [GSP1006]

# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install vault
vault server -dev
```
## Open a new Cloud Shell tab.

```
export VAULT_ADDR='http://127.0.0.1:8200'
vault auth enable approle
vault write auth/approle/role/jenkins policies="jenkins" period="24h"
vault read -format=json auth/approle/role/jenkins/role-id \
    | jq -r ".data.role_id" > role_id.txt
vault write -f -format=json auth/approle/role/jenkins/secret-id | jq -r ".data.secret_id" > secret_id.txt
vault write auth/approle/login role_id=$(cat role_id.txt) \
     secret_id=$(cat secret_id.txt)
```
## REPLACE YOUR TOKEN ID

```
vault token lookup <REPLACE YOUR TOKEN>
```
```
vault token lookup -format=json <REPLACE YOUR TOKEN> | jq -r .data.policies > token_policies.txt
```
```
export PROJECT_ID=$(gcloud config get-value project)
gsutil cp token_policies.txt gs://$PROJECT_ID
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
