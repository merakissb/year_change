class CreateExcelFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :excel_files do |t|
      t.string :action_type
      t.string :file_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
