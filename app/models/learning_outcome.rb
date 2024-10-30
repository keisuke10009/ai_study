class LearningOutcome < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :sum_rel
  
  belongs_to :user
  belongs_to :document

  validates :text, presence: true
end
