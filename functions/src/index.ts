import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
    .document('notifications')
    .onCreate(async snapshot => {


        const order = snapshot.data();

        const querySnapshot = await db
            .collection('users')
            .doc(order.userName)
            .collection('tokens')
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id);

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: 'New Follower!',
                body: `${order.userName} followed you`,
                icon: 'https://firebasestorage.googleapis.com/v0/b/whatnext-e7c13.appspot.com/o/wn_logo.png?alt=media&token=391b8edb-f5f5-446c-9109-a32373c34c7b',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });