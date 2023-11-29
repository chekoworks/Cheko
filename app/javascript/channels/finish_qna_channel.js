import consumer from "./consumer"


if(document.getElementById("chat_id")){

  const chat_id = document.getElementById("chat_id").value;
  consumer.subscriptions.create({channel: "FinishQnaChannel", chat_id: chat_id}, {
    connected() {
      console.log("CONNECTED FINISH")
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
    }
  });
}
