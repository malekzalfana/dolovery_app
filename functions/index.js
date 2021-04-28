const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
exports.myFunction = functions.firestore.document('users/{usersId}').onCreate((snapshot,context) => {
return admin.messaging().sendToTopic('user',{notification:{title:snapshot.data().full_name,body: snapshot.data().company,clickAction: 'FLUTTER_NOTIFICATION_CLICK',},
});
});

exports.myFunctionChange = functions.firestore.document('users/{usersId}').onUpdate((snapshot,context) => {
const after = snapshot.after.data();
return admin.messaging().sendToTopic('user',{notification:{title:after.full_name,body: after.company,clickAction: 'FLUTTER_NOTIFICATION_CLICK',},
});
});

exports.sendDevices = functions.firestore.document('users/{usersId}').onCreate((snapshot) => {

const name = snapshot.get("full_name");
const company = snapshot.get("company");
const token = snapshot.get("token");

return admin.messaging().sendToDevice(token,{notification:{title:"From" + name,body: "subject" + company,clickAction: 'FLUTTER_NOTIFICATION_CLICK',},
});
});