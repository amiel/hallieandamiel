class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|

      t.integer :photo_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
