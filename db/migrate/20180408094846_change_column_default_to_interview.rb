class ChangeColumnDefaultToInterview < ActiveRecord::Migration[5.1]
  def up
    change_column_default :interviews, :approval, 0
  end
  def down
    change_column_default :interviews, :approval, nil
  end
end
