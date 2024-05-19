import consumer from "./consumer"

consumer.subscriptions.create("HumanizeAnswerChannel", {
  connected() {
    console.log("Connected to HumanizeAnswerChannel");
  },

  disconnected() {
    console.log("Disconnected from HumanizeAnswerChannel");
  },

  received(data) {
    console.log("working....");
    console.log(data);
    $('.success_alert').find('span').html('Humanizing answer completed: <strong><a class="link-underline" href="/cheko-ai?conversation_id=' + data.conversation.id + '">' + data.conversation.title_name + '</a></strong>')
    $('.success_alert').show();
  }
});
