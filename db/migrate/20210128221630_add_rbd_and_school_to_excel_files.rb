class AddRbdAndSchoolToExcelFiles < ActiveRecord::Migration[6.0]
  def change
    add_column :excel_files, :school, :string
    add_column :excel_files, :rbd, :string
    
  end
end
