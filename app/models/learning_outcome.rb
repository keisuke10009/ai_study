class LearningOutcome < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :sum_rel
  
  belongs_to :user
  belongs_to :document

  validates :text, :sum_rel_id, :score, :assessment, presence: true
end
