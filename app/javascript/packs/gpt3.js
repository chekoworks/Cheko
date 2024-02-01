let currentDialogue = null; // Stores the current conversation. Messages[]
let userMessages = [];
let assistantMessages = [];
let sourceList = [];
let relatedList = [];
let promptsCount = 0; // How many prompts have been sent so far?
let autoScrollCount = 0;
let autoScrollMaxCount = 30000;

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
  chatBubble.classList.add("bg-new-cheko", "text-white", "border-0", "text-base", "font-semibold");

  sender === "user" ? chatBubble.innerHTML = content : typewriterEffect(chatBubble, content);

  if (sender != "user") {
    const bubbleContainer = document.createElement("div");
    bubbleContainer.classList.add('pb-4');
    bubbleContainer.style.maxWidth = '75%';

    const buttonsContainer = document.createElement("div");
    buttonsContainer.classList.add('flex', 'flex-row', 'justify-between');

    const rewriteHumanizeDiv = document.createElement("div");
    const copyEditButton = document.createElement("dev");

    const rewriteButton = document.createElement("button");
    rewriteButton.classList.add('chat-button');
    rewriteButton.innerHTML = '<i class="fa-solid fa-repeat" style="color: #ffffff;"></i> Rewrite';

    const humanizeButton = document.createElement("button");
    humanizeButton.classList.add('chat-button', 'pl-2', 'cheko-text-1');
    humanizeButton.setAttribute("id", "humanize-btn");
    humanizeButton.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles" style="color: #ffffff;"></i> Humanize';

    const copyButton = document.createElement("button");
    copyButton.classList.add('chat-button', 'cheko-text-1');
    copyButton.innerHTML = '<i class="fa-solid fa-copy cheko-text-1" ></i>';

    const editButton = document.createElement("button");
    editButton.classList.add('chat-button', 'pl-2', 'cheko-text-1');
    editButton.innerHTML = '<i class="fa-solid fa-edit cheko-text-1" ></i>';

    rewriteHumanizeDiv.appendChild(rewriteButton);
    rewriteHumanizeDiv.appendChild(humanizeButton);

    copyEditButton.appendChild(copyButton);
    copyEditButton.appendChild(editButton);

    buttonsContainer.appendChild(rewriteHumanizeDiv);
    buttonsContainer.appendChild(copyEditButton);

    bubbleContainer.appendChild(chatBubble);
    bubbleContainer.appendChild(buttonsContainer);

    return bubbleContainer;
  } else {
    return chatBubble;
  }
}

function old_autoScroll() {
  autoScrollCount += 2000;
  if (autoScrollCount <= autoScrollMaxCount) {
    document.getElementById('auto-scroll-anchor').scrollIntoView({ behavior: "smooth" });
    setTimeout(() => autoScroll(), 2000);
  }
}

function autoScroll() {
  setTimeout(() => {
    document.getElementById('auto-scroll-anchor').scrollIntoView({ behavior: "smooth" });
  }, 2000);
}

function typewriterEffect(element, content, i = 0) {
  element.innerHTML += content[i];

  if (i === content.length - 1) {
    return;
  }

  setTimeout(() => typewriterEffect(element, content, i + 1), 10);
}

const generateText = async (prompt, humanizeOrNot, citationOrNot) => {
  promptsCount++; // Increase prompt count
  autoScrollCount = 0;
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
  document.querySelector("textarea#prompt").disabled=true;
  // document.getElementById("generate-btn").setAttribute("disabled", true); // disable
  setLoading(true); // loading animation

  // Scroll into view
  setTimeout(() => {
    autoScroll();
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
  assistantMessages.push(json.generated_text);
  autoScroll();
  // -- Event Log --
  window.LOG_EVENTS.logSubmitPrompt(
    json.usage.prompt_tokens,
    json.usage.completion_tokens,
    json.usage.total_tokens,
    json.usage.model
  );

  // 4. Maintain a string record of the current dialogue between the user and the chatbot.
  currentDialogue = json.new_dialogue;

  const titleContainer = document.createElement("div"); // Holds the title and icon
  titleContainer.classList.add('pb-2')
  titleContainer.innerHTML = '<span class="title-header text-xl font-extrabold"><i class="fa-solid fa-align-left"></i> Answer </span>';
  chatContainer.appendChild(titleContainer);

  // 5. Get response and add as a chat bubble:
  const chekoResponse = json.generated_text
    .split("\n")
    .map((t) => `${t}`)
    .join("");
  chatContainer.appendChild(createChatBubble(chekoResponse, "cheko"));

  // 6. Finished Requesting: Re-enable button, turn off loading animation
  // document.getElementById("generate-btn").removeAttribute("disabled");
  setLoading(false); // loading animation

  autoScroll();

  // 7. Display a prompt after the 2nd
  // if (promptsCount === 2) {
  //   // Need a better answer? Work with our tutors in HW-Help or Q&A.
  //   // chatContainer.append(createChatBubble(``,"cheko"))

  //   setLoading(true); // loading animation
  //   setTimeout(() => {
  //     scrollContainer.scrollTop = scrollContainer.scrollHeight;
  //   }, 50);
  //   await fetch("/gpt3/render_better_answer_bubble")
  //     .then((response) => response.text())
  //     .then((data) => {
  //       setTimeout(() => {
  //         chatContainer.insertAdjacentHTML("beforeend", data);
  //         setLoading(false); // loading animation
  //         scrollContainer.scrollTop = scrollContainer.scrollHeight;
  //       }, 800);
  //     });
  // }

  // 7. Display related topics
  let automatedQuestion = 'Can you suggest 3 related questions or prompts to: ' + prompt + ' that are short and simple';
  let automatedResponse;

  try {
    automatedResponse = await fetch("/gpt3/generate_related", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        prompt: automatedQuestion
      }),
    });
  } catch (e) {
    console.log(e);

    setLoading(false);
    return;
  }

  // 4. Maintain a string record of the current dialogue between the user and the chatbot.
  currentDialogue = json.new_dialogue;

  autoScroll();

  // SCRAPING GOOGLE RESULTS
  const url = "https://www.googleapis.com/customsearch/v1?key=AIzaSyDXUK2pb4hfX4xQ_9-3vQRc4TrzqJU42fk&cx=271535145f8274dcc&q=" + prompt;

  // Add a Related Topics section in the container
  const responseJson = await automatedResponse.json();
  let chekoAutomatedResponse = responseJson.generated_text.split("\n");
  chekoAutomatedResponse.filter(item => !/^\s*$/.test(item)); // Filter empty
  chekoAutomatedResponse = checkForEmptyAndNotRelatedQuestion(chekoAutomatedResponse, prompt);
  var relatedDiv = document.createElement("div");
  // Related header with icon
  var headerDiv = document.createElement("div");
  relatedDiv.style.maxWidth = '75%';
  relatedDiv.style.marginBottom = '16px';
  headerDiv.classList.add('pt-4', 'pb-2');
  headerDiv.innerHTML = '<span class="title-header text-xl font-extrabold"><i class="fa-solid fa-layer-group" style="color: #ffffff;"></i> Related</span>'
  relatedDiv.appendChild(headerDiv);

  let processedRelatedList = []
  chekoAutomatedResponse.slice(0, 3).forEach(response => {
    const str = response.replace(/^\d+\.\s*/, '').toLowerCase();
    processedRelatedList.push(str);
    let bodyDiv = document.createElement("div");
    bodyDiv.classList.add('related-question', 'cheko-border-color-1');
    bodyDiv.innerHTML = str + '<i class="fa-solid fa-plus" style="color: #ffffff;"></i>';
    bodyDiv.style.pointer = 'cursor';
    relatedDiv.appendChild(bodyDiv);
  });

  relatedList.push({prompt: prompt, results: processedRelatedList});

  setTimeout(() => {
    run(url, prompt, chatContainer, relatedDiv);
    setLoading(false); // loading animation
    autoScroll();
  }, 2000);

  document.querySelector("textarea#prompt").disabled=false;

  // humanizeAnswers();

  // -- Event Log --
  window.LOG_EVENTS.logSubmitPrompt(
    responseJson.usage.prompt_tokens,
    responseJson.usage.completion_tokens,
    responseJson.usage.total_tokens,
    responseJson.usage.model
  );
  updateConversation();
  autoScroll();
};

async function fetchData(url) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error("HTTP error " + response.status);
  }
  return response.json();
}

async function scrapeQuestion(url, prompt) {
  try {
    const data = await fetchData(url);
    const results = data.items.slice(0, 4).map((item) => {
      const title = item.title;
      const link = item.link;
      const faviconUrl = `https://www.google.com/s2/favicons?domain=${new URL(link).hostname}`;
      return { title, link, faviconUrl };
    });

    sourceList.push({prompt: prompt, results: results});

    const mainContainer = document.createElement("div"); // Holds the title and source boxes
    const titleContainer = document.createElement("div"); // Holds the title and icon
    const sourcesContainer = document.createElement("div"); // Holds the source boxes

    mainContainer.classList.add('flex', 'flex-col', 'pb-4');
    mainContainer.style.maxWidth = '75%';
    titleContainer.classList.add('pt-4', 'pb-2');

    titleContainer.innerHTML = '<span class="title-header text-xl font-extrabold"><i class="fa-solid fa-list-ul" style="color: #ffffff;"></i> Sources </span>';
    mainContainer.appendChild(titleContainer);

    sourcesContainer.classList.add('flex', 'flex-row', 'justify-between');

    results.forEach(result => {
      const div = document.createElement("div");
      div.classList.add('source-box')

      const iconDiv = document.createElement("div");
      iconDiv.classList.add('flex', 'flex-row');


      const sourceImg = document.createElement("img");
      const sourceLink = document.createElement("a");

      sourceLink.classList.add('source-link');
      sourceLink.href = result.link;
      sourceLink.textContent = result.title;
      sourceLink.setAttribute('target', '_blank');

      sourceImg.src = result.faviconUrl;

      sourceImg.classList.add('size-5');

      iconDiv.appendChild(sourceImg);

      div.appendChild(sourceLink);
      div.appendChild(iconDiv);

      sourcesContainer.appendChild(div);

      updateConversation();
    });

    mainContainer.appendChild(sourcesContainer);
    return mainContainer;

  } catch (error) {
    console.log("There was a problem fetching the data: " + error.message);
  }
}

function checkForEmptyAndNotRelatedQuestion(response, prompt) {
  console.log(response);
  console.log(prompt);
  let related_questions = [];
  if (response.length >= 5) {
    response = response.slice(2);
  }
  response.forEach(function (related) {
    console.log(!related.includes(prompt));
    if (!related.includes(prompt) && related != '') {
      related_questions.push(related);
    }
  });

  return related_questions;
}

function addDivListener() {
  let relElements = document.querySelectorAll('.related-question');
  if (relElements) {
    relElements.forEach(function (element) {
      element.addEventListener('click', (e) => {
        const divText = element.textContent;
        generateText(divText, false);
      });
    });
  }
}

async function run(url, prompt, chatContainer, relatedDiv) {
  scrapeQuestion(url, prompt).then(container => {
    chatContainer.appendChild(container);
  });

  setTimeout(() => {
    chatContainer.appendChild(relatedDiv);
    addDivListener();
  }, 1000);

};

const saveConversation = async () => {
  let messageTitle = document.getElementById('message_title').innerText;
  if (messageTitle == 'New convo') {
    messageTitle = userMessages[0];
    document.getElementById('message_title').innerText = messageTitle;
  }
  let response =  await fetch("/gpt3/save_conversation", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      title: messageTitle,
      user_messages: userMessages,
      assistant_messages: assistantMessages,
      new_dialogue: currentDialogue,
      related_list: relatedList,
      source_list: sourceList
    }),
  });

  const json = await response.json();

  document.getElementById('conversation_id').value = json.id;
  addNewSideMenuConvoItem();
}

const updateTitle = async () => {
  toggleSaveConversationBtn(true);

  let messageTitle = document.getElementById('message_title').innerText;
  let conversationId = document.getElementById('conversation_id').value;
  if (conversationId == null || conversationId == undefined || conversationId == '') {
    saveConversation();
  } else {
    let response =  await fetch("/gpt3/update_title", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        id: conversationId,
        title: messageTitle
      }),
    });

    updateSideMenuConvoList();
  }
}

const updateConversation = async () => {
  toggleSaveConversationBtn(true);

  let messageTitle = document.getElementById('message_title').innerText;
  let conversationId = document.getElementById('conversation_id').value;
  if (conversationId == null || conversationId == undefined || conversationId == '') {
    saveConversation();
  } else {
    let response =  await fetch("/gpt3/update_conversation", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        id: conversationId,
        title: messageTitle,
        user_messages: userMessages,
        assistant_messages: assistantMessages,
        new_dialogue: currentDialogue,
        related_list: relatedList,
        source_list: sourceList
      }),
    });

    updateSideMenuConvoList();
  }
}

function toggleSaveConversationBtn(is_saved) {
  let save_btn = document.getElementById('save_conversation_btn');
  let save_text = document.getElementById('saved_text');
  if (is_saved) {
    if (!save_btn.classList.contains("hidden")) {
      save_btn.classList.add('hidden');
      save_btn.classList.remove('block');
    }
    if (!save_text.classList.contains("block")) {
      save_text.classList.add('block');
      save_text.classList.remove('hidden');
    }
  } else {
    if (!save_btn.classList.contains("block")) {
      save_btn.classList.add('block');
      save_btn.classList.remove('hidden');
    }

    if (!save_text.classList.contains("hidden")) {
      save_text.classList.add('hidden');
      save_text.classList.remove('block');
    }
  }
}

function updateSideMenuConvoList() {
  let messageTitle = document.getElementById('message_title').innerText;
  let conversationId = document.getElementById('conversation_id').value;
  if (conversationId == null || conversationId == undefined || conversationId == '') {
    document.getElementById('conversation-list-' + conversationId).innerText = messageTitle;
  }
}

function addNewSideMenuConvoItem() {
  let conversationListContainer = document.getElementById('conversation-list');
  let conversationId = document.getElementById('conversation_id').value;
  let convoLink = document.createElement("a"); // Holds the source boxes
  let messageTitle = document.getElementById('message_title').innerText;

  convoLink.classList.add('pl-2', 'hover:bg-neutral-700/30', 'w-full', 'py-1', 'block', 'my-2');
  convoLink.innerText = messageTitle;
  convoLink.href = "/cheko-ai?conversation_id=" + conversationId ;
  conversationListContainer.prepend(convoLink);
}

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
    userMessages.push(promptArea.value);
    generateText(promptArea.value);
    toggleSaveConversationBtn(false);
  }
});


let titleContainer = document.getElementById('message_title');
titleContainer.addEventListener("keydown", function (e) {
  // Get the code of pressed key
  const keyCode = e.which || e.keyCode;

  // 13 represents the Enter key
  if (keyCode === 13 && !e.shiftKey) {
    // Don't generate a new line
    e.preventDefault();
    titleContainer.blur();
  }
});

titleContainer.addEventListener("blur", function (e) {
  updateTitle();
  toggleSaveConversationBtn(false);
});

document.addEventListener('DOMContentLoaded', function() {
  if (document.getElementById('user_messages')) {
    let currentUserMessages = document.getElementById('user_messages').value;
    if (!(currentUserMessages == null || currentUserMessages == undefined || currentUserMessages == '')) {
      userMessages = JSON.parse(currentUserMessages);
    }
  }

  if (document.getElementById('assistant_messages')) {
    let currentAssistantMessages = document.getElementById('assistant_messages').value;
    if (!(currentAssistantMessages == null || currentAssistantMessages == undefined || currentAssistantMessages == '')) {
      assistantMessages = JSON.parse(currentAssistantMessages);
    }
  }

  autoScroll();
}, false);



let saveConversationBtn = document.getElementById('save_conversation_btn');
saveConversationBtn.addEventListener("click", function (e) {
  updateConversation();
});

document.querySelector("form").addEventListener("submit", (e) => {
  e.preventDefault();
  generateText(document.querySelector("textarea#prompt").value, false);
});

// -- Humanize Button --
// document
//   .querySelector("#humanize-text-button")
//   .addEventListener("click", (e) => {
//     e.preventDefault();
//     const prompt = `Craft this response in a manner that resembles the writing style of a college student. It should strike a balance between being relatable and sophisticated enough to fit seamlessly into a college paper or assignment: \n\n${document
//       .querySelector("#gpt-chat-container")
//       .lastChild.innerText}`;
//     generateText(prompt, true);
//   }
//   );



// -- Citation Button --
// document
//   .querySelector("#add-citations-button")
//   .addEventListener("click", (e) => {
//     e.preventDefault();
//     const prompt = `Search for citations: \n\n${document
//       .querySelector("#gpt-chat-container")
//       .lastChild.innerText}`;
//     generateText(prompt, false, true);
//   }
//   );

window.LOG_EVENTS.logChekoAIVisit();