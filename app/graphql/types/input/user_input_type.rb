module Types
  module Input
    class UserInputType < Types::BaseInputObject
      argument :username, String, required: true
      argument :email, String, required: true
    end
  end
end
