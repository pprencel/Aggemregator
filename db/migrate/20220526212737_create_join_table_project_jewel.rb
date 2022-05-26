class CreateJoinTableProjectJewel < ActiveRecord::Migration[7.0]
  def change
    create_join_table :projects, :jewels do |t|
      t.index [:project_id, :jewel_id], unique: true
      t.index [:jewel_id, :project_id], unique: true
    end
  end
end
