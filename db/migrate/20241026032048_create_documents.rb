class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :title,              null: false
      t.text :document,             null: false
      t.text :vocabulary,           null: false
      t.text :summary_ai,           null: false
      t.text :reflection_essay_ai,  null: false
      t.integer :level,             null: false
      t.integer :category,          null: false
    end
  end
end
