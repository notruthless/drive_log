class CreateLogEntries < ActiveRecord::Migration
  def self.up
    create_table :log_entries do |t|
      t.integer :user_id
      t.boolean :night
      t.string :notes
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
    add_index :log_entries, :user_id
  end

  def self.down
    drop_table :log_entries
  end
end
