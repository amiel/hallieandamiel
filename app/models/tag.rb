class Tag < ActiveRecord::Base
  
  has_many :taggings
  has_many :photos, :through => :taggings
  
  def random_photo
    @random_photo ||= photos.offset(rand(photos.count)).first
  end
  
end
