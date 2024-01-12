import consumer from "./consumer"
 
consumer.subscriptions.create({ channel: "CommentsChannel"}, {
  
  connected() {
   console.log("connected to comments channel")
    this.perform("follow", {question_id: gon.question_id} )
  },

  received(data) {
    console.log(data)
    if (gon.current_user == gon.author) {
      return 
    }
    else {
     var element =  document.querySelector('.'+data.commentable_name+'_'+data.commentable_id+'_comments')
     console.log(element)
      element.insertAdjacentHTML("beforeend", data.partial)
    }
  }

})

