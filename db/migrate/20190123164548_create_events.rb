class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :update_type
      t.string :start_time
      t.string :end_time
      t.string :location
      t.string :invitee_name
      t.integer :duration
      t.string :event_kind

      t.timestamps
    end
  end
end
