class Tag < ActiveRecord::Base

  has_many :taggings
  has_many :photos, through: :taggings

  scope :people, where(category: 'person').order('tag ASC')
  scope :other, where(category: nil).order('tag ASC')

  def photographer?
    category == 'user'
  end

  def person?
    category == 'person'
  end

  def to_s
    if photographer?
      "Photographer: #{tag}"
    else
      tag
    end
  end

  def random_photo
    @random_photo ||= photos.offset(rand(photos.count)).first
  end

end
