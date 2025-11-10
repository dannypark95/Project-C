const {onCall} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");
const {initializeApp} = require("firebase-admin/app");
const {GoogleGenerativeAI} = require("@google/generative-ai");

// Initialize Firebase Admin
initializeApp();

// Define secret for Gemini API key (set via Firebase Console or CLI)
const geminiApiKey = defineSecret("GEMINI_API_KEY");

// Initialize Gemini AI
// API key is set via Firebase Secrets (from GitHub Secrets during deployment)
// Never commit the API key to the repository!
let genAI;
if (geminiApiKey.value()) {
  genAI = new GoogleGenerativeAI(geminiApiKey.value());
} else {
  console.error("⚠️ GEMINI_API_KEY secret is not set!");
  // Fallback to environment variable for local development
  const fallbackKey = process.env.GEMINI_API_KEY || "";
  if (fallbackKey) {
    genAI = new GoogleGenerativeAI(fallbackKey);
  } else {
    throw new Error("GEMINI_API_KEY is required. Set it as a Firebase secret.");
  }
}

// System prompt for the AI assistant
const SYSTEM_PROMPT = `You are "Aura," a caring and empathetic AI companion. ` +
    `Your purpose is to provide a supportive, non-judgmental space for ` +
    `users to reflect and find comfort.

IMPORTANT GUIDELINES:
- You are NOT a therapist, psychiatrist, or medical professional
- You MUST NOT provide diagnoses, medical advice, or treatment plans
- Your tone is always calm, encouraging, and gentle
- Focus on active listening, validation, and supportive responses
- Help users reflect on their feelings and experiences
- Suggest general wellness practices (breathing exercises, journaling,
  mindfulness)
- If a user expresses feelings of hopelessness, gently encourage them to
  reflect on small positive things

CRISIS INTERVENTION:
If a user mentions suicide, self-harm, or severe crisis, you MUST
immediately respond with:
"I hear that you're in a lot of pain, and it's important to talk to
someone who can help. Please reach out to the 988 Suicide & Crisis
Lifeline (call or text 988) or contact emergency services (911). You
don't have to go through this alone."

Keep your responses concise, warm, and supportive. Always end with an
open-ended question to encourage continued conversation.`;

/**
 * Checks if a message contains crisis keywords.
 * @param {string} message - The message to check.
 * @return {boolean} True if crisis keywords are found.
 */
function containsCrisisKeywords(message) {
  const crisisKeywords = [
    "suicide",
    "kill myself",
    "end my life",
    "self-harm",
    "hurt myself",
    "want to die",
    "not worth living",
  ];
  const lowerMessage = message.toLowerCase();
  return crisisKeywords.some((keyword) => lowerMessage.includes(keyword));
}

// Cloud Function to handle chat with AI
exports.chatWithAI = onCall(
    {
      cors: true,
      maxInstances: 10,
      secrets: [geminiApiKey], // Use the secret
    },
    async (request) => {
      try {
        const {message} = request.data;

        // Validate input
        if (!message || typeof message !== "string") {
          return {error: "Message is required"};
        }

        // Check for crisis keywords first
        if (containsCrisisKeywords(message)) {
          const crisisResponse = "I hear that you're in a lot of pain, " +
              "and it's important to talk to someone who can help. " +
              "Please reach out to the 988 Suicide & Crisis Lifeline " +
              "(call or text 988) or contact emergency services (911). " +
              "You don't have to go through this alone.";
          return {
            response: crisisResponse,
          };
        }

        // Get the Gemini model
        const model = genAI.getGenerativeModel({model: "gemini-1.5-flash"});

        // Create the full prompt with system instructions
        const fullPrompt = `${SYSTEM_PROMPT}\n\nUser: ${message}\n\nAura:`;

        // Generate response
        const result = await model.generateContent(fullPrompt);
        const response = result.response;
        const text = response.text();

        return {
          response: text,
        };
      } catch (error) {
        console.error("Error in chatWithAI:", error);
        return {
          error: "An error occurred while processing your message. " +
              "Please try again.",
        };
      }
    }
);

