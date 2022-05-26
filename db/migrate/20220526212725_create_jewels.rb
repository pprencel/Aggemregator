class CreateJewels < ActiveRecord::Migration[7.0]
  def change
    create_table :jewels do |t|
      t.string :name

      t.timestamps
    end
  end
end
