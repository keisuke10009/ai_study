class Comment < ApplicationRecord
  
  belongs_to :user
  belongs_to :learning_outcome
end
