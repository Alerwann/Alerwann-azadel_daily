const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

// Initialise Firebase Admin
admin.initializeApp();

// Fonction qui se déclenche tous les jours à 5h du matin (heure de Paris)
exports.resetHeartColor = onSchedule(
  {
    schedule: "0 5 * * *",
    timeZone: "Europe/Paris",
  },
  async (event) => {
    try {
      // Remet la couleur à "red" dans Firestore
      await admin.firestore().collection("appState").doc("hearts").update({
        selectedColor: "grey",
      });

      console.log("Couleur réinitialisée à red à 5h du matin");
    } catch (error) {
      console.error("Erreur lors de la réinitialisation:", error);
    }
  }
);
