const functions = require('firebase-functions');
const algoliasearch = require('algoliasearch');
const algoliaSync = require('algolia-firestore-sync');

const algolia = algoliasearch("OHHGNC99AS", "a6b56f040dea346c56268af333d8c790");
const index = algolia.initIndex('products');

exports.syncProducts = functions.firestore.document('/products_temp/{id}').onWrite(
  (change, context) => {
    return algoliaSync.syncAlgoliaWithFirestore(index, change, context)
  }
);