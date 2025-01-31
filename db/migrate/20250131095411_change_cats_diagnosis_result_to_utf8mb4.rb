class ChangeCatsDiagnosisResultToUtf8mb4 < ActiveRecord::Migration[7.1]
  def up
    execute "ALTER TABLE cats MODIFY diagnosis_result VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;"
  end

  def down
    execute "ALTER TABLE cats MODIFY diagnosis_result VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci;"
  end
end
