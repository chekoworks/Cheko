import mixpanel from "mixpanel-browser";
import { Tooltip } from 'flowbite';

let currentDialogue = null; // Stores the current conversation. Messages[]
let userMessages = [];
let assistantMessages = [];
let sourceList = [];
let relatedList = [];
let imageList = [];
let promptsCount = 0; // How many prompts have been sent so far?
let autoScrollCount = 0;
let autoScrollMaxCount = 30000;
let typed = null;
let isTypedStopped = false;
let currentConvoPosition = null;
let currentSessionId = null;

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

function createChatBubble(content, sender, showEditBtn) {
  const chatBubble = document.createElement("div");
  chatBubble.className =
    sender === "user" ? "chat-bubble-user" : "chat-bubble-cheko";
  chatBubble.classList.add("bg-new-cheko", "text-white", "border-0", "text-base", "markdown-body");
  chatBubble.innerHTML = content;
  // if (sender === "user") {
  //   chatBubble.innerHTML = content;
  // } else {
  //   typewriterEffect(chatBubble, content, () => {
  //
  //     if(typeof rewriteButton !== 'undefined' && rewriteButton !== null)
  //       rewriteButton.disabled = false;
  //
  //     if(typeof humanizeButton !== 'undefined' && humanizeButton !== null)
  //       humanizeButton.disabled = false;
  //
  //     if(typeof copyButton !== 'undefined' && copyButton !== null)
  //       copyButton.disabled = false;
  //
  //     // Enable source links and related question links similarly
  //     document.querySelectorAll('.source-link.disabled-link').forEach(link => {
  //       link.classList.remove('disabled-link');
  //     });
  //     document.querySelectorAll('.related-question.disabled-link').forEach(link => {
  //       link.classList.remove('disabled-link');
  //     });
  //   });
  // }

  if (sender != "user") {
    const bubbleContainer = document.createElement("div");
    bubbleContainer.classList.add('pb-4');

    const buttonsContainer = document.createElement("div");
    buttonsContainer.classList.add('flex', 'flex-row', 'justify-between');

    const rewriteHumanizeDiv = document.createElement("div");
    const copyEditButton = document.createElement("div");
2
    const rewriteButton = document.createElement("button");
    rewriteButton.classList.add('chat-button', 'rewrite-btn');
    rewriteButton.innerHTML = '<i class="fa-solid fa-repeat" style="color: #ffffff;"></i> Rewrite';
    rewriteButton.disabled = true;

    const humanizeButton = document.createElement("button");
    humanizeButton.classList.add('chat-button', 'pl-2', 'cheko-text-1', 'humanize-btn');
    humanizeButton.setAttribute("id", "humanize-btn");
    humanizeButton.innerHTML = '<i class="fa-solid fa-wand-magic-sparkles" style="color: #ffffff;"></i> Humanize';
    humanizeButton.disabled = true;

    const copyButton = document.createElement("button");
    copyButton.classList.add('chat-button', 'cheko-text-1', 'copy-btn');
    copyButton.setAttribute('id', 'copy-btn');
    copyButton.setAttribute('data-tooltip-target', 'tooltip-default');
    copyButton.setAttribute('data-tooltip-trigger', 'hover');
    copyButton.innerHTML = '<i class="fa-solid fa-copy cheko-text-1" ></i>';
    copyButton.disabled = true;

    let is_user_signed_in = $('#is_user_signed_in').val();

    rewriteHumanizeDiv.appendChild(humanizeButton);
    if (is_user_signed_in == 'true') {
      rewriteHumanizeDiv.appendChild(rewriteButton);
    }

    copyEditButton.appendChild(copyButton);

    buttonsContainer.appendChild(rewriteHumanizeDiv);
    buttonsContainer.appendChild(copyEditButton);

    bubbleContainer.appendChild(chatBubble);
    bubbleContainer.appendChild(buttonsContainer);


    return bubbleContainer;
  } else {
    chatBubble.classList.add("max-w-full");

    const bubbleContainer = document.createElement("div");
    bubbleContainer.classList.add('self-end', 'my-2');
    bubbleContainer.append(chatBubble);

    if (showEditBtn) {
      const actionDiv = document.createElement("div");
      actionDiv.classList.add('text-right');
      const editButton = document.createElement("button");
      editButton.classList.add('chat-button', 'pl-2', 'cheko-text-1', 'edit-btn');
      editButton.innerHTML = '<i class="fa-solid fa-edit cheko-text-1" ></i>';
      actionDiv.appendChild(editButton);
      bubbleContainer.append(actionDiv);
    }
    return bubbleContainer;
  }
}

function autoScroll() {
  setTimeout(() => {
    document.getElementById('auto-scroll-anchor').scrollIntoView({behavior: "smooth"});
  }, 2000);
}

function typewriterEffect(element, content, onComplete) {
  if(typed !==	null){
    $('#cheko-loading-bubble').remove();
  }

  typed = new Typed(element, {
    strings: [content],
    typeSpeed: 0,
    onComplete: onComplete // Call the callback function when typing is complete
  });
  isTypedStopped	= false;

  function checkVisibilityAndTyped() {
    if (document.hidden && !typed.complete) {
      typed.start(); // Start Typed.js if tab is visible and typing is not complete
    }
  }

// Check visibility and typed status every 500 milliseconds
  setInterval(checkVisibilityAndTyped, 500);
  // element.innerHTML += content[i];
  // if (i === content.length - 1) {
  //   return;
  // }
  // setTimeout(() => typewriterEffect(element, content, i + 1), 10);
}

function stopTyping() {
  if (typed !== null) {

    // stop	the typing effect
    typed.stop();

    isTypedStopped = true;

    // remove disabled-link class from all .source-link
    document.querySelector("textarea#prompt").disabled = false;

    // scan all .related-question and remove disabled-link class
    $('.related-question').each(function() {
      $(this).removeClass('disabled-link');
    });

  }
}

const humanizeText = async(prompt, position) => {
  autoScroll();
  let groupConvoContainer = $('.group-convo-container-' + position);
  let chatContent = groupConvoContainer.find('.chat-content');
  showLoadingBubble(chatContent);
  let conversation_id = document.getElementById('conversation_id').value;

  let response;

  try {
    response = await fetch("/gpt3/humanize", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ prompt, position, conversation_id, currentDialogue }),
    });

  } catch (e) {
    console.log(e);

    setLoading(false);
    return;
  }
  const json = await response.json();
  let content_data = json.content;
  next_humanize_available_date_str = json.next_humanize_available_date;
  datetime_now_str = json.datetime_now;
  showCountdown();
  autoScroll();

  if ($('#cheko-loading-bubble').length > 0) {
    $('#cheko-loading-bubble').remove();
  }

  let humanizeTextContainer = chatContent.find('.humanized_answers_container_' + position);

  if (humanizeTextContainer.length) {
    let listContainer = humanizeTextContainer.find('.humanize_list');
    let data_html = '<li class="text-white">\n' +
                        content_data +'\n' +
      '                            </li>';
    listContainer.append(data_html);
  } else {
    let data_html = '<div class="chat-bubble-content humanized_answers_container_' + position + '" style="margin-bottom: 16px;">\n' +
      '                        <div class="pt-4 pb-2">\n' +
      '                              <span class="title-header text-xl font-extrabold">\n' +
      '                                <i class="fa-solid fa-chalkboard-user" style="color: #ffffff;"></i>\n' +
      '                                Humanized Answer/s:\n' +
      '                              </span>\n' +
      '                        </div>\n' +
      '                        <ol class="humanize_list space-y-2 text-gray-500 list-decimal list-inside dark:text-gray-400">\n' +
      '                            <li class="text-white">\n' +
                                      content_data +'\n' +
      '                            </li>\n' +
      '                        </ol>\n' +
      '                     </div>';
    chatContent.append(data_html);
  }

  // 6. Finished Requesting: Re-enable button, turn off loading animation
  // document.getElementById("generate-btn").removeAttribute("disabled");
  // setLoading(false); // loading animation

  autoScroll();
}

const generateText = async (prompt, index, is_rewrite, current_result) => {
  promptsCount++; // Increase prompt count
  autoScrollCount = 0;

  $('.getting_started_container').hide();

  // Utils:
  let convoContainer = null;
  let groupConvoContainer = null;
  let imageContainer = null;
  if (index != null) {
    groupConvoContainer = $('.group-convo-container-' + index);
    convoContainer = $('.convo-container-' + index);
    convoContainer.html('');
    imageContainer = $('.chat-image-' + index);
    imageContainer.html('');

    currentConvoPosition = index;
  } else {
    const chatContainer = document.getElementById("gpt-chat-container");
    const groupBubbleContainer = document.createElement("div");
    groupBubbleContainer.classList.add('group-convo-container-' +userMessages.length, 'w-100', 'flex', 'py-8', 'border-bottom', 'border-gray-600');
    chatContainer.appendChild(groupBubbleContainer);

    const chatContent = document.createElement("div");
    chatContent.classList.add('chat-content', 'w-75');
    groupBubbleContainer.appendChild(chatContent);

    const imageContent = document.createElement("div");
    imageContent.classList.add('chat-image', 'w-25', 'pt-8', 'pl-8', 'hidden');
    groupBubbleContainer.appendChild(imageContent);

    imageContent.innerHTML = ' <div class="pt-4 pb-2">\n' +
      '                      <span class="title-header text-xl font-extrabold">\n' +
      '                        <i class="fa-regular fa-images" style="color: #ffffff;"></i>\n' +
      '                        Images\n' +
      '                      </span>\n' +
      '                    </div>';

    const imageContentContainer = document.createElement("div");
    imageContentContainer.classList.add('chat-image-'+userMessages.length, 'grid', 'grid-cols-2', 'gap-4', 'justify-between');
    imageContent.appendChild(imageContentContainer);

    const bubbleContainer = document.createElement("div");
    chatContent.classList.add('chat-bubble-container', 'convo-container-' +userMessages.length);
    groupBubbleContainer.appendChild(bubbleContainer);

    convoContainer = $('.convo-container-' +userMessages.length);
    convoContainer.data('index', userMessages.length);
    groupConvoContainer = $('.group-convo-container-' +userMessages.length);
    groupConvoContainer.data('index', userMessages.length);
    imageContainer = $('.chat-image-'+userMessages.length);
    imageContainer.data('index', userMessages.length);


    currentConvoPosition = userMessages.length;
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

  showLoadingBubble(convoContainer);

  // 3. Send Prompt to Controller:
  let response;
  let generate_url = '/gpt3/generate_v2';
  let generate_body = JSON.stringify({ prompt, currentDialogue, currentSessionId });

  if (is_rewrite) {
    generate_url = '/gpt3/rewrite_v2';
    generate_body = JSON.stringify({ prompt, current_result, currentDialogue, currentSessionId })
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

  if	(isTypedStopped)
    return;

  const json = await response.json();
  let content_data = json.content;
  let source_data = json.sources;
  let image_data = json.images;
  currentSessionId = json.session_id;
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

  convoContainer.append('<h1 class="text-3xl text-white my-4">' + prompt + '</h1>');
  showImage(imageContainer, image_data);

  showSource(convoContainer,source_data);
  sourceList.push({prompt: prompt, results: source_data});
  autoScroll();

  // 4. Maintain a string record of the current dialogue between the user and the chatbot.
  currentDialogue = content_data.new_dialogue;
  showAnswer(convoContainer, content_data.markdown_text)
  // set the tooltip content element
  const $targetEl = document.querySelector('.convo-container-' +userMessages.length + ' #tooltip-default');
  // set the element that trigger the tooltip using hover or click
  const $triggerEl = document.querySelector('.convo-container-' +userMessages.length+ ' #copy-btn');
  enableCopyTooltip($targetEl, $triggerEl)
  autoScroll();

  showRelatedQuestions(convoContainer,related_question_data);
  relatedList.push({prompt: prompt, results: related_question_data});
  autoScroll();

  imageList.push(image_data);

  document.querySelector("textarea#prompt").disabled=false;
  $('.rewrite-btn, .humanize-btn').prop('disabled', false);

  mixpanel.track("ask a prompt", json);
  if ($('#user_id').val() !== "" && $('#user_id').val() !== null) {
    updateConversation();
  }
  autoScroll();


};

function showImage(container_element, images) {
  if (images.length > 0) {
    container_element.parent().removeClass('hidden');
    images.forEach(function(convo_image, index) {
      console.log(index );
      if (index >= 5) return;

      var divClass = index == 0 ? "col-span-2" : "col-span-1";

      var $div = $('<div>').addClass(divClass);
      var $a = $('<a>').attr('href', convo_image['original']).attr('target', '_blank');
      var $img = $('<img>').attr('src', convo_image['thumbnail']).addClass('w-full h-auto');

      $a.append($img);
      $div.append($a);

      container_element.append($div); // Append to the body or another container element
    });
  }
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

function enableCopyTooltip($targetEl, $triggerEl) {
  const options = {
    placement: 'bottom',
    triggerType: 'click',
    onHide: () => {
      console.log('tooltip is shown');
    },
    onShow: (elem) => {
      setTimeout(() => {
        elem.hide();
      }, 3000);
    },
    onToggle: () => {
      console.log('tooltip is toggled');
    },
  };
  const instanceOptions = {
    id: 'tooltip-default',
    override: true
  };
  const tooltip = new Tooltip($targetEl, $triggerEl, options, instanceOptions);
  tooltip.init();
}

function showLoadingBubble(container_element) {

  // check if cheko-loading-bubble	already exists and remove it
  if ($('#cheko-loading-bubble').length > 0) {
    $('#cheko-loading-bubble').remove();
  }

  container_element.append('<div class="bg-new-cheko text-white border-0 text-md font-semibold" id="cheko-loading-bubble">\n' +
    '      <div class="loading-text inline"></div>' +
    '    </div>');

  // try {
  // 		if(typed !==	null)
  // 			$('#cheko-loading-bubble').remove();
  // } catch (e) {
  // 		console.log(e);
  // }

  typed = new Typed('.loading-text', {
    strings: ["Searching web...", "Checking for sources...", "Looking for related questions...", "Summarizing answers..."],
    typeSpeed: 50,
    loop: true
  });
  isTypedStopped = false;
}

function showSource(container_element, sources) {
  let data_html = '<div class="flex flex-col pb-4 chat-bubble-content">\n' +
    '<div class="pt-4 pb-2">\n' +
    '<span class="title-header text-xl font-extrabold">\n' +
    '<i class="fa-solid fa-list-ul" style="color: #ffffff;"></i>\n' +
    'Sources\n' +
    '</span>\n' +
    '</div>\n' +
    '<div class="flex flex-row justify-between gap-x-2">';
  sources.forEach((source, index) => {
    if (index >= 4) {
      return;
    }
    data_html += '<a class="rounded-md flex w-full ring-borderMain bg-new-cheko text-white p-2 source-link disabled-link" href="' + (source.url || source.link) + '" target="_blank">\n' +
      '<div class="relative flex items max-w-full flex-col justify-between h-full pointer-events-none select-none px-sm pt-sm pb-xs">\n' +
      '<div>\n' +
      '<div class="line-clamp-2 grow default font-sans text-xs font-medium text-textMain dark:text-textMainDark selection:bg-superDuper selection:text-textMain">\n' +
      source.title +
      '</div>\n' +
      '</div>\n' +
      '<div class="flex items-center space-x-xs">\n' +
      '<div class="flex items-center gap-x-xs ring-borderMain dark:ring-borderMainDark bg-transparent border-borderMain/60 dark:border-borderMainDark/80 divide-borderMain/60 dark:divide-borderMainDark/80">\n' +
      '<div class="relative flex-none">\n' +
      '<div class="rounded-full overflow-hidden">\n' +
      '<img alt="'+ (source.domain_name || source.source) +' favicon" class="block" src="https://www.google.com/s2/favicons?domain=' + (source.url || source.link) + '&sz=16" width="16" height="16">\n' +
      '</div>\n' +
      '</div>\n' +
      '<div class="duration-300 transition-all line-clamp-1 break-all light text-gray-500 font-sans text-xs ml-1 font-medium text-textOff dark:text-textOffDark selection:bg-superDuper selection:text-textMain">\n' +
      (source.domain_name || source.source) +
      '</div>\n' +
      '</div>\n' +
      '<h2 class="text-gray-500 mx-1 light font-display text-lg font-medium text-textOff dark:text-textOffDark selection:bg-superDuper selection:text-textMain">·</h2>\n' +
      '<div class="light font-sans text-xs font-medium text-textOff dark:text-textOffDark selection:bg-superDuper selection:text-textMain">\n' +
      (index+1) +
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
  let data_html = '<div class="chat-bubble-content" style="margin-bottom: 16px;">\n' +
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
    data_html += '<span class="related-question cheko-border-color-1 disabled-link">\n' +
      related_question.question +
      '<i class="fa-solid fa-plus" style="color: #ffffff;"></i>\n' +
      '</span>'
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
      source_list: sourceList,
      images: imageList,
      position: currentConvoPosition
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
        source_list: sourceList,
        images: imageList,
        position: currentConvoPosition
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
  $('html').addClass('overflow-hidden max-h-screen');
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
  if (document.getElementById('session_id')) {
    let sessionId = document.getElementById('session_id').value;
    if (!(sessionId == null || sessionId == undefined || sessionId == '')) {
      currentSessionId = sessionId;
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

document.querySelector("#stop_button").addEventListener("click", (e) => {
  stopTyping();
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

  // find if has class disabled-link and return if true
  if ($(this).hasClass('disabled-link')) {
    return;
  } else {
    // find all related questions and add disabled-link class
    $('.related-question').each(function() {
      $(this).addClass('disabled-link');
    });

    userMessages.push(divText);
    generateText(divText);
  }
});

// -- Humanize Button --
$('body').on('click', '.humanize-btn', function() {
  let is_user_signed_in = $('#is_user_signed_in').val();
  if (is_user_signed_in == 'true') {
    let prompt = $(this).parent().parent().parent().find('.chat-bubble-cheko').text();
    let position = $(this).parent().parent().parent().parent().data('index');
    humanizeText(prompt, position);
  }
});

// -- Copy Button --
$('body').on('click', '.copy-btn', function() {
  let prompt = $(this).parent().parent().parent().find('.chat-bubble-cheko').text();
  navigator.clipboard.writeText(prompt).then(() => {
    console.log('Content copied to clipboard');
    $('.copy-alert-container').fadeIn("fast");

    setTimeout(() => {
      $('.copy-alert-container').fadeOut("slow");
    }, 2000);
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
  let index = $(this).parent().parent().parent().data('index');
  let prompt = $(this).parent().parent().parent().parent().find('.chat-bubble-user').text().trim();
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


$('body').on('mouseenter','.sidebar-conversation-item-list', function (event) {
  $(this).find('.delete_conversation_btn').show();
}).on('mouseleave','.sidebar-conversation-item-list',  function(){
  $(this).find('.delete_conversation_btn').hide();
});

$('body').on('click', '.delete_conversation_btn', function() {
  let delete_conversation_btn = $(this);
  let conversation_id = delete_conversation_btn.data('conversation_id');
  var data = {
    conversation_id: conversation_id
  }

  $.ajax({
    method: "post",
    url: '/gpt3/delete_conversation',
    data: data
  }).done(function(response) {
    delete_conversation_btn.parent().remove();
  });
});