class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.string :image_url
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
