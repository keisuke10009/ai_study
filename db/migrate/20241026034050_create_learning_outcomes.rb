class CreateLearningOutcomes < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_outcomes do |t|
      t.integer :sum_rel_id,    null: false
      t.text :text,             null: false
      t.integer :score,         null: false
      t.text :assessment,       null: false
      t.references :user,       null: false, foreign_key: true
      t.references :document,   null: false, foreign_key: true
      t.timestamps
    end
  end
end
