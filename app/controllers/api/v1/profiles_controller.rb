class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    render json: current_resource_owner, serializer:  Api::V1::ProfileSerializer
  end

  def index
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users, each_serializer: Api::V1::ProfileSerializer
  end
end
