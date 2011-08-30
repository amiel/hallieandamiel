class AddDeletedAtToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :deleted_at, :datetime
  end
end
