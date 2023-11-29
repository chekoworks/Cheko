/**
 * 🔴 WARNING 🔴
 * Do not import this module twice within packs. e.g. importing within applications.js and gpt3.js.
 * This will appear twice and will actually run twice.
 *
 * How to use properly:
 * - 1. Just import within applications.js
 * - 2. Expose the exported variables within application.js
 * - 3. Use the exported variables within another file in `packs` like gpt3.js, and use normally as if it already exists.
 */

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { logEvent, getAnalytics } from "firebase/analytics";

console.log("FIREBASE IS LOADED");

const firebaseConfig = {
  apiKey: "AIzaSyCn5sQ2TaZVUMglmDibI9nhKHVtjfRunBA",
  authDomain: "cheko-analytics.firebaseapp.com",
  projectId: "cheko-analytics",
  storageBucket: "cheko-analytics.appspot.com",
  messagingSenderId: "591823572362",
  appId: "1:591823572362:web:fbcb15000a3ed8adc6cc73",
  measurementId: "G-K5W6GG8Z9B",
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

// CustomEvents
const logSubmitPrompt = (
  promptTokens,
  completionTokens,
  totalTokens,
  modelUsed
) => {
  logEvent(analytics, "submit_prompt", {
    prompt_tokens: promptTokens,
    completion_tokens: completionTokens,
    total_tokens: totalTokens,
    model_used: modelUsed,
  });
};

const logChekoAIVisit = () => {
  logEvent(analytics, "visit_cheko_ai");
  console.log("logged cheko visit!");
};

// Expose CustomEvents via window by creating a LOG_EVENTS variable:
window.LOG_EVENTS = {
  logSubmitPrompt,
  logChekoAIVisit,
};
