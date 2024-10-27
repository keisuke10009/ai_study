class RenameLevelToLevelIdInDocuments < ActiveRecord::Migration[7.0]
  def change
    rename_column :documents, :level, :level_id
  end
end
