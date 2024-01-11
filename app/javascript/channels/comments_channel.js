import consumer from "./consumer"
 
consumer.subscriptions.create({ channel: "CommentsChannel"}, {
  
  connected() {
   console.log("connected to comments channel")
    this.perform("follow", {question_id: gon.question_id} )
  },

  received(data) {
 
    if (gon.current_user == gon.author) {
      return 
    }
    else {
     var element =  document.querySelector('.answer_'+data.commentable_id+'_comments')
      element.insertAdjacentHTML("beforeend", data.partial)
    }
  }

})

