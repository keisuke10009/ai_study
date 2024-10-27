class RenameCategoryToCategoryIdInDocuments < ActiveRecord::Migration[7.0]
  def change
    rename_column :documents, :category, :category_id
  end
end
