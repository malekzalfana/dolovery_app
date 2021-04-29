// const functions = require('firebase-functions');

// const algoliasearch = require('algoliasearch');
// const algoliaFunctions = require('algolia-firebase-functions');

// const algolia = algoliasearch(functions.config().algolia.app,
//                               functions.config().algolia.key);
// const index = algolia.initIndex(functions.config().algolia.index);
const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');



// const admin = require('firebase-admin');

const APP_ID = functions.config().algolia.app;
const ADMIN_KEY = functions.config().algolia.key;

const client = algoliasearch('OHHGNC99AS', '7e607340632a51227a660d7b8edeaf66');
const index = client.initIndex('products');


// const algolia = algoliasearch('OHHGNC99AS',
//     '7e607340632a51227a660d7b8edeaf66');
// const index = algolia.initIndex('products');


exports.addToIndex = functions.firestore.document('products/{productId}')

    .onCreate(snapshot => {

        const data = snapshot.data();
        const objectID = snapshot.id;

        return index.saveObject({ objectID, data });

    });

exports.updateIndex = functions.firestore.document('products/{productId}')

    .onUpdate((change) => {
        const data = change.after.data();
        const objectID = change.after.id;
        return index.saveObject({ objectID, data });
    });


exports.deleteFromIndex = functions.firestore.document('products/{productId}')

    .onDelete(snapshot =>
        index.deleteObject(snapshot.id)
    );

admin.initializeApp(functions.config().firebase);
var msgData;


admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();

exports.senddevices = functions.firestore
  .document("shop_orders/{id}")
  .onCreate((snapshot) => {
    const name = 'snapshot.get("name")';
    const subject = 'snapshot.get("subject")';
    const token = 'd8HunRNCXD0:APA91bGCcODt5AWlpioriHCfBGG6toHeZzbwh9RERLtYes-9y9VcpPvY21vhz_vCHAN9KHA46mqs-nAbwqDo59apX-DPKi8qsJor52CKsvRtX9TJs3c60TZqR32ubPveI-uor2XDuzmK';

    const payload = {
      notification: {
        title: "from " + name,
        body: "subject " + subject,
        sound: "default",
      },
    };

    return fcm.sendToDevice(token, payload);
  }); 
