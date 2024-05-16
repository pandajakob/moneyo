// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.0/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-analytics.js";
import { 
    getFirestore, collection, getDocs,
    addDoc
} from "https://www.gstatic.com/firebasejs/10.10.0/firebase-firestore.js"
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyBxUijoVOg787I6GrOcSZIpSwGdNE6_Tqk",
    authDomain: "moneyo-4567d.firebaseapp.com",
    projectId: "moneyo-4567d",
    storageBucket: "moneyo-4567d.appspot.com",
    messagingSenderId: "35737258382",
    appId: "1:35737258382:web:3042e232547be30887bcdf",
    measurementId: "G-R7RYSS1Q77"
  };

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);


const db = getFirestore()
const bubblesColRef = collection(db, "bubbles")

let mainElement = document.getElementById("main")

getDocs(bubblesColRef)
.then((snapshot) => {
    let bubbles = [];

    snapshot.docs.forEach((doc) => {
        bubbles.push({ ...doc.data(), id: doc.id });
    })

    const sortedData = bubbles.sort((a, b) => {
        const dateA = a.timestamp.toDate();
        const dateB = b.timestamp.toDate();
        return dateA - dateB;
    });
    bubbles.forEach((bubble) => {
        let bubbleDiv = document.getElementByTagName("main").createElement("div");
        bubbleDiv.className = "bubble"

        const bubbleName = document.createElement("p")
        text.innerHTML =   bubble.name;
        text.className = "text";

        bubbleDiv.appendChild(bubbleName);
        mainElement.appendChild(bubbleDiv)
    })
})
.catch(err => {
    console.log(err);
})
