import consumer from "./consumer"
 
consumer.subscriptions.create({ channel: "CommentsChannel"}, {
  
  connected() {
   console.log("connected to comments channel")
    this.perform("follow", {question_id: gon.question_id} )
  },

  received(data) {
    console.log(data)
 
     var element =  document.querySelector('.'+data.commentable_name+'_'+data.commentable_id+'_comments')
     console.log(element)
      element.insertAdjacentHTML("beforeend", data.partial)
      hide_form(data)
    }
  })

function hide_form(data){
  $(document).ready(function(){
    $('#comment_body').val('');
    $('form#comment-'+data.commentable_type+'-'+data.commentable_id).addClass('hidden');
    $('.comment-answer-link').show()
  })
}


