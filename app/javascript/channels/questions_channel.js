import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {

 received(data) {
  console.log(data)
    const element =  document.querySelector(".questions_list")
    element.insertAdjacentHTML("beforeend", data)
  }
})
