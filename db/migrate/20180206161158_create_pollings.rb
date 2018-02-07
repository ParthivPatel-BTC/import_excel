class CreatePollings < ActiveRecord::Migration
  def change
    create_table :pollings do |t|
      t.text :process_id
      t.boolean :is_running, default: true

      t.timestamps null: false
    end
  end
end
