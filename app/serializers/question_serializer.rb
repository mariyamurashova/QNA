class QuestionSerializer < ActiveModel::Serializer 
 attributes :id, :title, :body, :created_at, :updated_at, :short_title, :files, :comments, :links
 has_many :answers
belongs_to :author


  def short_title
    object.title.truncate(7)
  end

  def files 
    if object.files.attached?
      urls=[ ]
      object.files.each do |file| 
        urls << Rails.application.routes.url_helpers.rails_blob_url(file.blob, only_path: true) 
    end
    return urls
    end
  end

  def comments
    object.comments
  end

  def links
    object.links
  end
end
 
