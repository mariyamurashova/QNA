class Api::V1::ProfileSerializer < ActiveModel::Serializer
   %i[id email admin created_at updated_at]
end
