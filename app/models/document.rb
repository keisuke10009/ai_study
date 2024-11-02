class Document < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :level
  belongs_to :category

  has_many :learning_outcomes

end
