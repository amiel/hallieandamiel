class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|

      t.string    :uploader_name
      t.string    :uploader_email
      t.string    :uploader_ip

      t.boolean   :approved, :default => false
      
      t.string    :photo_file_name
      t.string    :photo_content_type
      t.integer   :photo_file_size
      t.datetime  :photo_updated_at

      t.timestamps
    end
  end
end
