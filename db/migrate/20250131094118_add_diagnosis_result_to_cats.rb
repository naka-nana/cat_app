class AddDiagnosisResultToCats < ActiveRecord::Migration[7.1]
  def change
    add_column :cats, :diagnosis_result, :string
  end
end
