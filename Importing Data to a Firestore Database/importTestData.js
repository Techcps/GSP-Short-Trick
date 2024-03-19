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
