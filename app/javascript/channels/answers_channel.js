import consumer from "./consumer"
 
consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id}, {
  
  received(data) {
  console.log(data)
  console.log(gon.current_user, data.answer_author)
    if (gon.current_user == data.answer_author) {

      return 
    }
    else {
      const element =  document.querySelector(".answers")
      element.insertAdjacentHTML("beforeend", data.partial)
    }
  }
})
