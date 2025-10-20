const { onSchedule } = require("firebase-functions/v2/scheduler");
const {
  onDocumentUpdated,
  onDocumentCreated,
  onDocumentDeleted,
} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
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

exports.notifyHeartChange = onDocumentUpdated(
  "appState/hearts",
  async (event) => {
    try {
      // Récupérer les données avant et après le changement
      const beforeData = event.data.before.data();
      const afterData = event.data.after.data();

      const oldColor = beforeData.selectedColor;
      const newColor = afterData.selectedColor;

      // Si la couleur n'a pas changé, on arrête
      if (oldColor === newColor || newColor == "grey") {
        console.log("Couleur identique, pas de notification");
        return;
      }

      console.log(`Couleur changée: ${oldColor} → ${newColor}`);

      // Récupérer tous les tokens des appareils
      const tokensSnapshot = await admin
        .firestore()
        .collection("deviceTokens")
        .get();

      const tokens = tokensSnapshot.docs.map((doc) => doc.data().token);

      if (tokens.length === 0) {
        console.log("Aucun token trouvé");
        return;
      }

      console.log(`Envoi à ${tokens.length} appareil(s)`);

      // Créer le message de notification
      const message = {
        notification: {
          title: "❤️ Le cœur a changé !",
          body: `Ton amour a changé le cœur en ${getColorName(newColor)}`,
        },
        tokens: tokens,
      };

      // Envoyer la notification
      const response = await admin.messaging().sendEachForMulticast(message);

      console.log(`${response.successCount} notification(s) envoyée(s)`);
      console.log(`${response.failureCount} échec(s)`);
    } catch (error) {
      console.error("Erreur lors de l'envoi de notification:", error);
    }
  }
);

function getColorName(color) {
  switch (color) {
    case "red":
      return "rouge";
    case "blue":
      return "bleu";
    case "green":
      return "vert";
    case "yellow":
      return "jaune";
    case "grey":
      return "gris";
    default:
      return color;
  }
}
exports.onTopicCreated = onDocumentCreated(
  "topics/{topicId}",
  async (event) => {
    const newTopic = event.data.data();
    const topicTitle = newTopic.title;

    console.log("Nouveau topic créé:", topicTitle);
    const tokensSnapshot = await admin
      .firestore()
      .collection("deviceTokens")
      .get();

    const tokens = tokensSnapshot.docs.map((doc) => doc.data().token);

    if (tokens.length === 0) {
      console.log("Aucun appareil enregistré");
      return;
    }

    const message = {
      notification: {
        title: "🛒 Nouvelle course ajoutée",
        body: `${topicTitle} a été ajouté à la liste`,
      },
      tokens: tokens,
    };

    try {
      const response = await admin.messaging().sendEachForMulticast(message);
      console.log("✅ Envoyé:", response.successCount);
    } catch (error) {
      console.error("Erreur:", error);
    }
  }
);

exports.onTopicDeleted = onDocumentDeleted(
  "topics/{topicId}",
  async (event) => {
    const deletedTopic = event.data.data();
    const topicTitle = deletedTopic.title;
    console.log("Topic supprimé:", topicTitle);
    // Même logique que onCreate
    const tokensSnapshot = await admin
      .firestore()
      .collection("deviceTokens")
      .get();

    const tokens = tokensSnapshot.docs.map((doc) => doc.data().token);

    if (tokens.length === 0) return;

    const message = {
      notification: {
        title: "🗑️ Course supprimée",
        body: `${topicTitle} a été retiré de la liste`,
      },
      tokens: tokens,
    };

    try {
      const response = await admin.messaging().sendEachForMulticast(message);
      console.log("✅ Envoyé:", response.successCount);
    } catch (error) {
      console.error("Erreur:", error);
    }
  }
);
