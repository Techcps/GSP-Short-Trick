
gcloud auth list
gcloud config list project

git clone https://github.com/rosera/pet-theory
cd pet-theory/lab01
npm install @google-cloud/firestore
npm install @google-cloud/logging

cat > importTestData.js <<EOF_CP
const csv = require('csv-parse');
const fs = require('fs');
const { Firestore } = require("@google-cloud/firestore");
const { Logging } = require('@google-cloud/logging');

const logName = "pet-theory-logs-importTestData";

// Creates a Firestore client
const db = new Firestore();
const logging = new Logging();
const log = logging.log(logName);

const resource = {
  type: "global",
};

async function writeToFirestore(records) {
  const batch = db.batch();

  records.forEach((record) => {
    console.log(`Write: ${record}`);
    const docRef = db.collection("customers").doc(record.email);
    batch.set(docRef, record, { merge: true });
  });

  batch.commit()
    .then(() => {
       console.log('Batch executed');
    })
    .catch(err => {
       console.log(`Batch error: ${err}`);
    });
}

async function importCsv(csvFilename) {
  const parser = csv.parse({ columns: true, delimiter: ',' }, async function (err, records) {
    if (err) {
      console.error('Error parsing CSV:', err);
      return;
    }
    try {
      console.log(`Call write to Firestore`);
      await writeToFirestore(records);
      const success_message = `Success: importTestData - Wrote ${records.length} records`;
      const entry = log.entry({ resource: resource }, { message: `${success_message}` });
      log.write([entry]);
      console.log(`Wrote ${records.length} records`);
    } catch (e) {
      console.error(e);
      process.exit(1);
    }
  });

  await fs.createReadStream(csvFilename).pipe(parser);
}

if (process.argv.length < 3) {
  console.error('Please include a path to a csv file');
  process.exit(1);
}

importCsv(process.argv[2]).catch(e => console.error(e));

EOF_CP

npm install faker@5.5.3

cat > createTestData.js <<EOF_CP
const fs = require('fs');
const faker = require('faker');
const { Logging } = require("@google-cloud/logging");

function getRandomCustomerEmail(firstName, lastName) {
  const provider = faker.internet.domainName();
  const email = faker.internet.email(firstName, lastName, provider);
  return email.toLowerCase();
}

// Logging constants and client initialization
const logName = "pet-theory-logs-createTestData";
const logging = new Logging();
const log = logging.log(logName);
const resource = {
  type: "global",
};

async function createTestData(recordCount) {
  const fileName = `customers_${recordCount}.csv`;
  var f = fs.createWriteStream(fileName);
  f.write('id,name,email,phone\n')
  for (let i=0; i<recordCount; i++) {
    const id = faker.datatype.number();
    const firstName = faker.name.firstName();
    const lastName = faker.name.lastName();
    const name = `${firstName} ${lastName}`;
    const email = getRandomCustomerEmail(firstName, lastName);
    const phone = faker.phone.phoneNumber();
    f.write(`${id},${name},${email},${phone}\n`);
  }
  console.log(`Created file ${fileName} containing ${recordCount} records.`);

  // Logging success message
  const success_message = `Success: createTestData - Created file ${fileName} containing ${recordCount} records.`;
  const entry = log.entry(
    { resource: resource },
    {
      name: `${fileName}`,
      recordCount: `${recordCount}`,
      message: `${success_message}`,
    }
  );
  log.write([entry]);
}

recordCount = parseInt(process.argv[2]);
if (process.argv.length != 3 || recordCount < 1 || isNaN(recordCount)) {
  console.error('Include the number of test data records to create. Example:');
  console.error('    node createTestData.js 100');
  process.exit(1);
}

createTestData(recordCount);
EOF_CP

node createTestData 1000
node importTestData customers_1000.csv
npm install csv-parse
