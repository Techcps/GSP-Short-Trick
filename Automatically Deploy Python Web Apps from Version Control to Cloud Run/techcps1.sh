

gcloud auth list

export PROJECT_ID=$(gcloud config get-value project)

gcloud config set project "$(gcloud projects list | awk '/PROJECT_ID/{print $2}' | head -1)"

gcloud services enable \
    cloudbuild.googleapis.com \
    run.googleapis.com


cd ~

mkdir helloworld

cd helloworld

cat > requirements.txt << "EOF"
Flask==3.0.0
gunicorn==20.1.0
EOF

touch main.py

cat > main.py <<EOF_CP
import os

from flask import Flask

app = Flask(__name__)

app_version = "0.0.0"

@app.route("/")
def hello_world():
    return f"Hello! This is version {app_version} of my application."


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
EOF_CP


cd ~/helloworld

git init -b main

curl -sS https://webi.sh/gh | sh


gh auth login

gh api user -q ".login"

GITHUB_USERNAME=$(gh api user -q ".login")


echo ${GITHUB_USERNAME}


git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "${USER_EMAIL}"


git add .

git commit -m "initial commit"


cd ~/helloworld


gh repo create hello-world --private


git remote add origin \
https://github.com/${GITHUB_USERNAME}/hello-world


git push -u origin main


echo -e "\n\nTo see your code, visit this URL:\n \
https://github.com/${GITHUB_USERNAME}/hello-world/blob/main/main.py \n\n"


echo "Click the click to open https://console.cloud.google.com/run"
