let currentDialogue = null; // Stores the current conversation. Messages[]
let promptsCount = 0; // How many prompts have been sent so far?

/**
 * Returns a Chat Bubble Element as a Div.
 *
 * content: string
 *
 * sender: "user" | "cheko"
 */
function createChatBubble(content, sender) {
  const chatBubble = document.createElement("div");
  chatBubble.className =
    sender === "user" ? "chat-bubble-user" : "chat-bubble-cheko";
  chatBubble.innerHTML = content;
  return chatBubble;
}

const generateText = async (prompt, humanizeOrNot, citationOrNot) => {
  promptsCount++; // Increase prompt count

  // Utils:
  const chekoLoadingBubble = document.getElementById("cheko-loading-bubble");
  function setLoading(bool) {
    if (bool) {
      chekoLoadingBubble.classList.remove("d-none"); // loading animation
    } else {
      chekoLoadingBubble.classList.add("d-none"); // loading animation
    }
  }

  // 1. Start requesting: Clear Chatbox, Disable Button, Play Loading Animation
  document.querySelector("textarea#prompt").value = ""; // clear
  document.getElementById("generate-btn").setAttribute("disabled", true); // disable
  setLoading(true); // loading animation

  // Scroll into view
  const scrollContainer = document.getElementsByClassName("card-body-top")[0];
  setTimeout(() => {
    scrollContainer.scrollTop = scrollContainer.scrollHeight;
  }, 50);

  // 2. Add prompt as a chat bubble:

  const chatContainer = document.getElementById("gpt-chat-container");
  const text = humanizeOrNot ? "Humanizing text.." : citationOrNot ? "Adding citation.." : prompt;
  chatContainer.appendChild(createChatBubble(text, "user"));

  // 3. Send Prompt to Controller:
  let response;

  try {
    response = await fetch("/gpt3/generate", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ prompt, currentDialogue }),
    });
  } catch (e) {
    console.log(e);

    setLoading(false);
    return;
  }

  const json = await response.json();

  // -- Event Log --
  window.LOG_EVENTS.logSubmitPrompt(
    json.usage.prompt_tokens,
    json.usage.completion_tokens,
    json.usage.total_tokens,
    json.usage.model
  );

  // 4. Maintain a string record of the current dialogue between the user and the chatbot.
  currentDialogue = json.new_dialogue;
  // console.log(currentDialogue);

  // 5. Get response and add as a chat bubble:
  const chekoResponse = json.generated_text
    .split("\n")
    .map((t) => `<p>${t}</p>`)
    .join("");
  chatContainer.appendChild(createChatBubble(chekoResponse, "cheko"));

  // 6. Finished Requesting: Re-enable button, turn off loading animation
  document.getElementById("generate-btn").removeAttribute("disabled");
  setLoading(false); // loading animation

  scrollContainer.scrollTop = scrollContainer.scrollHeight;

  // 7. Display a prompt after the 2nd
  if (promptsCount === 2) {
    // Need a better answer? Work with our tutors in HW-Help or Q&A.
    // chatContainer.append(createChatBubble(``,"cheko"))

    setLoading(true); // loading animation
    setTimeout(() => {
      scrollContainer.scrollTop = scrollContainer.scrollHeight;
    }, 50);
    await fetch("/gpt3/render_better_answer_bubble")
      .then((response) => response.text())
      .then((data) => {
        setTimeout(() => {
          chatContainer.insertAdjacentHTML("beforeend", data);
          setLoading(false); // loading animation
          scrollContainer.scrollTop = scrollContainer.scrollHeight;
        }, 800);
      });
  }
};

// -- Submit Event Listener --
const promptArea = document.querySelector("textarea#prompt");

promptArea.addEventListener("keydown", function (e) {
  // Get the code of pressed key
  const keyCode = e.which || e.keyCode;

  // 13 represents the Enter key
  if (keyCode === 13 && !e.shiftKey) {
    // Don't generate a new line
    e.preventDefault();

    // Do something else such as send the message to back-end
    // ...
    generateText(promptArea.value);
  }
});

document.querySelector("form").addEventListener("submit", (e) => {
  e.preventDefault();
  generateText(document.querySelector("textarea#prompt").value, false);
});

// -- Humanize Button --
document
  .querySelector("#humanize-text-button")
  .addEventListener("click", (e) => {
    e.preventDefault();
    const prompt = `Craft this response in a manner that resembles the writing style of a college student. It should strike a balance between being relatable and sophisticated enough to fit seamlessly into a college paper or assignment: \n\n${document
      .querySelector("#gpt-chat-container")
      .lastChild.innerText}`;
    generateText(prompt, true);
  }
  );

// -- Citation Button --
document
  .querySelector("#add-citations-button")
  .addEventListener("click", (e) => {
    e.preventDefault();
    const prompt = `Search for citations: \n\n${document
      .querySelector("#gpt-chat-container")
      .lastChild.innerText}`;
    generateText(prompt, false, true);
  }
  );

window.LOG_EVENTS.logChekoAIVisit();
