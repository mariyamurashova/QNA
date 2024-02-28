class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :author_id, :comments, :created_at, :updated_at, :links, :files

  def comments
    object.comments.each do |comment|
      comment.body 
    end
  end

  def links
    object.links.each do |link| 
      link.url 
    end
  end

  def files
    urls=[ ]
    object.files.each do |file| 
      urls << Rails.application.routes.url_helpers.rails_blob_url(file.blob, only_path: true) 
    end
    return urls
  end
end
