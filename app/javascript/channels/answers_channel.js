import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel"}, {
  
  connected() {
    this.perform("follow", {question_id: gon.question_id} )
  },

  received(data) {
  console.log(data)

    if (gon.current_user == gon.author) {
      return 
    }
    else {
      const element =  document.querySelector(".answers")
      element.insertAdjacentHTML("beforeend", data)
    }
  }
})
