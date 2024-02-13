import mixpanel from "mixpanel-browser";

let currentDialogue = null; // Stores the current conversation. Messages[]
let userMessages = [];
let assistantMessages = [];
let sourceList = [];
let relatedList = [];
let promptsCount = 0; // How many prompts have been sent so far?
let autoScrollCount = 0;
let autoScrollMaxCount = 30000;

mixpanel.init("36da7c6fa99e6a22866f300e549fef43", {
  loaded: function () {
    console.log('mixpanel initialized...')
  }
});

/**
 * Returns a Chat Bubble Element as a Div.
 *
 * content: string
 *
 * sender: "user" | "cheko"
 */
import Typed from 'typed.js';

function createChatBubble(content, sender) {
  const chatBubble = document.createElement("div");
  chatBubble.className =
    sender === "user" ? "chat-bubble-user" : "chat-bubble-cheko";
  chatBubble.classList.add("bg-new-cheko", "text-white", "border-0", "text-base");

  sender === "user" ? chatBubble.innerHTML = content : typewriterEffect(chatBubble, content);

  if (sender != "user") {
    const bubbleContainer = document.createElement("div");
    bubbleContainer.classList.add('pb-4');
    bubbleContainer.style.maxWidth = '75%';

    const buttonsContainer = document.createElement("div");
    buttonsContainer.classList.add('flex', 'flex-row', 'justify-between');

    const rewriteHumanizeDiv = document.createElement("div");
    const copyEditButton = document.createElement("div");

    const rewriteButton = document.createElement("button");
    rewriteButton.classList.add('chat-button', 'rewrite-btn');
    rewriteButton.innerHTML = '<i class="fa-solid fa-repeat" style="color: #ffffff;"></i> Rewrite';

    const humanizeButton = document.createElement("button");
    humanizeButton.classList.add('chat-button', 'pl-2', 'cheko-text-1', 'humanize-btn');
    humanizeButton.setAttribute("id", "humanize-btn");
    humanizeButton.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles" style="color: #ffffff;"></i> Humanize';

    const copyButton = document.createElement("button");
    copyButton.classList.add('chat-button', 'cheko-text-1', 'copy-btn');
    copyButton.setAttribute('id','copy-btn');
    copyButton.setAttribute('data-tooltip-target', 'copy-btn-tooltip');
    copyButton.setAttribute('data-tooltip-trigger', 'click');
    copyButton.innerHTML = '<i class="fa-solid fa-copy cheko-text-1" ></i>';


    const editButton = document.createElement("button");
    editButton.classList.add('chat-button', 'pl-2', 'cheko-text-1', 'edit-btn');
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

function autoScroll() {
  setTimeout(() => {
    document.getElementById('auto-scroll-anchor').scrollIntoView({ behavior: "smooth" });
  }, 2000);
}

function typewriterEffect(element, content, i = 0) {

  new Typed(element, {
    strings: [content],
    typeSpeed: 10
  });
  // element.innerHTML += content[i];
  // if (i === content.length - 1) {
  //   return;
  // }
  // setTimeout(() => typewriterEffect(element, content, i + 1), 10);
}

const humanizeText = async(prompt, element) => {
  // Utils:
  const chekoLoadingBubble = document.getElementById("cheko-loading-bubble");
  function setLoading(bool) {
    if (bool) {
      chekoLoadingBubble.classList.remove("d-none"); // loading animation
    } else {
      chekoLoadingBubble.classList.add("d-none"); // loading animation
    }
  }
  const chatContainer = document.getElementById("gpt-chat-container");
  const text = "Humanizing text.."
  chatContainer.appendChild(createChatBubble(text, "user"));
  setLoading(true);

  let response;

  try {
    response = await fetch("/gpt3/humanize", {
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
}

const generateText = async (prompt, index, is_rewrite, current_result) => {
  promptsCount++; // Increase prompt count
  autoScrollCount = 0;
  // Utils:
  let convoContainer = null;
  if (index != null) {
    convoContainer = $('.convo-container-' + index);
    convoContainer.html('');
  } else {
    const chatContainer = document.getElementById("gpt-chat-container");
    const bubbleContainer = document.createElement("div");
    bubbleContainer.classList.add('chat-bubble-container', 'convo-container-' +userMessages.length);
    chatContainer.appendChild(bubbleContainer);
    convoContainer = $('.convo-container-' +userMessages.length);
    convoContainer.data('index', userMessages.length);
  }


  // 1. Start requesting: Clear Chatbox, Disable Button, Play Loading Animation
  document.querySelector("textarea#prompt").value = ""; // clear
  document.querySelector("textarea#prompt").disabled=true;
  // document.getElementById("generate-btn").setAttribute("disabled", true); // disable

  // Scroll into view
  setTimeout(() => {
    autoScroll();
  }, 50);

  // 2. Add prompt as a chat bubble:

  convoContainer.append(createChatBubble(prompt, "user"));
  showLoadingBubble(convoContainer);

  // 3. Send Prompt to Controller:
  let response;
  let generate_url = '/gpt3/generate';
  let generate_body = JSON.stringify({ prompt, currentDialogue });

  if (is_rewrite) {
    generate_url = '/gpt3/rewrite';
    generate_body = JSON.stringify({ prompt, current_result, currentDialogue })
  }

  try {
    response = await fetch(generate_url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: generate_body,
    });

  } catch (e) {
    $('#cheko-loading-bubble').remove();
    return;
  }

  const json = await response.json();
  let content_data = json.content;
  let source_data = json.sources;
  let related_question_data = json.related_questions;
  $('#cheko-loading-bubble').remove();
  if (index != null) {
    assistantMessages[index] = content_data.generated_text;
  } else {
    assistantMessages.push(content_data.generated_text);
  }
  autoScroll();
  // -- Event Log --
  window.LOG_EVENTS.logSubmitPrompt(
    content_data.usage.prompt_tokens,
    content_data.usage.completion_tokens,
    content_data.usage.total_tokens,
    content_data.usage.model
  );

  showSource(convoContainer,source_data);
  sourceList.push({prompt: prompt, results: source_data});
  autoScroll();

  // 4. Maintain a string record of the current dialogue between the user and the chatbot.
  currentDialogue = content_data.new_dialogue;
  showAnswer(convoContainer, content_data.markdown_text)
  autoScroll();

  showRelatedQuestions(convoContainer,related_question_data);
  relatedList.push({prompt: prompt, results: related_question_data});
  autoScroll();

  document.querySelector("textarea#prompt").disabled=false;

  mixpanel.track("ask a prompt", json);
  if ($('#user_id').val() !== "" && $('#user_id').val() !== null) {
    updateConversation();
  }
  autoScroll();


};


function checkForEmptyAndNotRelatedQuestion(response, prompt) {
  let related_questions = [];
  if (response.length >= 5) {
    response = response.slice(2);
  }
  response.forEach(function (related) {
    if (!related.includes(prompt) && related != '') {
      related_questions.push(related);
    }
  });

  return related_questions;
}

function showAnswer(container_element, generated_text) {
  const titleContainer = document.createElement("div"); // Holds the title and icon
  titleContainer.classList.add('pb-2')
  titleContainer.innerHTML = '<span class="title-header text-xl font-extrabold"><i class="fa-solid fa-align-left"></i> Answer </span>';
  container_element.append(titleContainer);

  // 5. Get response and add as a chat bubble:
  const chekoResponse = generated_text
    .split("\n")
    .map((t) => `${t}`)
    .join("");
  container_element.append(createChatBubble(chekoResponse, "cheko"));
}

function showLoadingBubble(container_element) {
  container_element.append('<div class="bg-new-cheko text-white border-0 text-md font-semibold" id="cheko-loading-bubble">\n' +
    '      <div class="loading-text inline"></div>' +
    '    </div>');
  new Typed('.loading-text', {
    strings: ["Searching web...", "Checking for sources...", "Looking for related questions...", "Summarizing answers..."],
    typeSpeed: 50,
    loop: true
  });
}

function showSource(container_element, sources) {
  let data_html = '<div class="flex flex-col pb-4 chat-bubble-content" style="max-width: 75%;">\n' +
      '<div class="pt-4 pb-2">\n' +
        '<span class="title-header text-xl font-extrabold">\n' +
          '<i class="fa-solid fa-list-ul" style="color: #ffffff;"></i>\n' +
            'Sources\n' +
        '</span>\n' +
      '</div>\n' +
      '<div class="flex flex-row justify-between gap-x-2">';
  sources.forEach(source => {
    if (source.position >= 5) {
      return;
    }
    data_html += '<a class="rounded-md flex w-full ring-borderMain bg-new-cheko text-white p-2" href="' + source.link + '" target="_blank">\n' +
        '<div class="relative z-10 flex items max-w-full flex-col justify-between h-full pointer-events-none select-none px-sm pt-sm pb-xs">\n' +
          '<div>\n' +
            '<div class="line-clamp-2 grow default font-sans text-xs font-medium text-textMain dark:text-textMainDark selection:bg-superDuper selection:text-textMain">\n' +
              source.title +
            '</div>\n' +
          '</div>\n' +
          '<div class="flex items-center space-x-xs">\n' +
            '<div class="flex items-center gap-x-xs ring-borderMain dark:ring-borderMainDark bg-transparent border-borderMain/60 dark:border-borderMainDark/80 divide-borderMain/60 dark:divide-borderMainDark/80">\n' +
              '<div class="relative flex-none">\n' +
                '<div class="rounded-full overflow-hidden">\n' +
                  '<img alt="'+ source.source +' favicon" class="block" src="' + source.favicon + '" width="16" height="16">\n' +
                '</div>\n' +
              '</div>\n' +
              '<div class="duration-300 transition-all line-clamp-1 break-all light text-gray-500 font-sans text-xs ml-1 font-medium text-textOff dark:text-textOffDark selection:bg-superDuper selection:text-textMain">\n' +
                source.source +
              '</div>\n' +
            '</div>\n' +
            '<h2 class="text-gray-500 mx-1 light font-display text-lg font-medium text-textOff dark:text-textOffDark selection:bg-superDuper selection:text-textMain">·</h2>\n' +
            '<div class="light font-sans text-xs font-medium text-textOff dark:text-textOffDark selection:bg-superDuper selection:text-textMain">\n' +
              source.position +
            '</div>\n' +
          '</div>\n' +
        '</div>\n' +
      '</a>';
  });
  data_html += '</div>\n' +
    '</div>';

  container_element.append(data_html)
}

function showRelatedQuestions(container_element, related_questions) {
  let data_html = '<div class="chat-bubble-content" style="max-width: 75%; margin-bottom: 16px;">\n' +
      '<div class="pt-4 pb-2">\n' +
        '<span class="title-header text-xl font-extrabold">\n' +
          '<i class="fa-solid fa-layer-group" style="color: #ffffff;"></i>\n' +
            'Related\n' +
        '</span>\n' +
      '</div>';

  related_questions.forEach((related_question, index) => {
    if (index >= 3) {
      return;
    }
    data_html += '<a href="' + related_question.link + '" class="related-question cheko-border-color-1">\n' +
        related_question.question +
        '<i class="fa-solid fa-plus" style="color: #ffffff;"></i>\n' +
      '</a>'
  });
  data_html += '</div>';
  container_element.append(data_html);
}

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

function updatePromptAndGenerateMessage() {
  let edit_prompt_container = $('.edit_prompt_container');
  let prompt = edit_prompt_container.find('#edit-prompt').val();
  let index = $('#edit_prompt_index_id').val();
  generateText(prompt, index)
  $('.edit_prompt_container').addClass('hidden');

  setTimeout(() => {
    edit_prompt_container.find('#edit-prompt').val('');
    $('#edit_prompt_index_id').val(0);
  }, 1500);
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
  generateText(document.querySelector("textarea#prompt").value);
});

// -- Sample Question Button --
$('body').on('click', '.sample-question', function() {
  const divText = $(this).text();
  userMessages.push(divText);
  generateText(divText);
});

// -- Related Question Button --
$('body').on('click', '.related-question', function() {
  const divText = $(this).text();
  userMessages.push(divText);
  generateText(divText);
});

// -- Humanize Button --
$('body').on('click', '.humanize-btn', function() {
  let prompt = $(this).parent().parent().parent().find('.chat-bubble-cheko').text();
  humanizeText(prompt, null);
});

// -- Copy Button --
$('body').on('click', '.copy-btn', function() {
  let prompt = $(this).parent().parent().parent().find('.chat-bubble-cheko').text();
  navigator.clipboard.writeText(prompt).then(() => {
    console.log('Content copied to clipboard');
    /* Resolved - text copied to clipboard successfully */
  },() => {
    console.error('Failed to copy');
    /* Rejected - text failed to copy to the clipboard */
  });
});

// -- Rewrite Button --
$('body').on('click', '.rewrite-btn', function() {
  let index = $(this).parent().parent().parent().parent().data('index');
  let prompt = $(this).parent().parent().parent().parent().find('.chat-bubble-user').text();
  let current_result = $(this).parent().parent().parent().parent().find('.chat-bubble-cheko').text();
  generateText(prompt, index, true, current_result);
});

// -- Edit Button --
$('body').on('click', '.edit-btn', function() {
  let index = $(this).parent().parent().parent().parent().data('index');
  let prompt = $(this).parent().parent().parent().parent().find('.chat-bubble-user').text();
  let edit_prompt_container = $('.edit_prompt_container');
  edit_prompt_container.find('#edit-prompt').val(prompt);
  $('#edit_prompt_index_id').val(index);
  $('.edit_prompt_container').removeClass('hidden');

  edit_prompt_container.find('#edit-prompt').focus();
});

// -- Cancel Edit Button --
$('body').on('click', '#edit_cancel_btn', function() {
  let edit_prompt_container = $('.edit_prompt_container');
  edit_prompt_container.find('#edit-prompt').val('');
  $('#edit_prompt_index_id').val(0);
  $('.edit_prompt_container').addClass('hidden');
});

// -- Save Edit Button / Enter Key --
$('body').on('click', '#edit_save_btn', function() {
  updatePromptAndGenerateMessage();
});
$('body').on('keydown', '#edit-prompt', function(e) {
  const keyCode = e.which || e.keyCode;

  // 13 represents the Enter key
  if (keyCode === 13 && !e.shiftKey) {
    updatePromptAndGenerateMessage();
  }
});

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