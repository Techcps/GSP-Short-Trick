
gcloud auth list
gcloud config list project

git clone https://github.com/rosera/pet-theory
cd pet-theory/lab01
npm install @google-cloud/firestore
npm install @google-cloud/logging

curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Importing%20Data%20to%20a%20Firestore%20Database/importTestData.js

npm install faker@5.5.3

curl -LO raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Importing%20Data%20to%20a%20Firestore%20Database/createTestData.js

node createTestData 1000
node importTestData customers_1000.csv
npm install csv-parse
