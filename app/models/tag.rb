class Tag < ActiveRecord::Base
  
  has_many :taggings
  has_many :photos, :through => :taggings       
  
  scope :non_user, where(category: nil)
  
  def to_s
    self.tag
  end 
  
  def random_photo
    @random_photo ||= photos.offset(rand(photos.count)).first
  end
  
end
