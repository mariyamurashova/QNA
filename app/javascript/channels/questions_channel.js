import consumer from "./consumer"

consumer.subscriptions.create({ channel: "QuestionsChannel"}, {

 received(data) {
  console.log(data)
   this.appendLine(data)
  },
   appendLine(data) {
    const html = this.createLine(data)
    const element =  document.querySelector("#questions_list")
    element.insertAdjacentHTML("beforeend", html)
  },

    createLine(data) {
    return `
      <article class="chat-line">
      <a href=http://localhost:3000/questions/${data["question_id"]}>${data["question_title"]}</a>
        `
  }
})
