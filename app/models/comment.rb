class Comment < ApplicationRecord
  belongs_to :sum_rel
  
  belongs_to :user
  belongs_to :learning_outcome
  
end
