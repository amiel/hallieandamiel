class Photo < ActiveRecord::Base
  paginates_per 10

  has_many :taggings
  has_many :tags, :through => :taggings
  
  has_attached_file :photo, :styles => { :full => "960x720>", :thumbnail => "100x100>" }, # TODO: pick better sizes (nathan perhaps?)
    :storage => :s3,
    :s3_credentials => Rails.root.join('config/paperclip.yml'),
    :s3_headers => {'Expires' => 1.year.from_now.httpdate }
  
  default_scope where(:approved => true)

  after_create :tag_uploader
  
  validates_presence_of :photo
  validates_format_of :uploader_email, :with => /^\w(\.?[\w-])*@\w(\.?[\w-])*\.[a-z]{2,6}$/i, :allow_blank => true # TODO: testme
  
  def uploader
    # TODO: just pre-@ part of emails? or possibly extract first name?
  end
  
  def tag_uploader
    if uploader_name and not uploader_name.blank? then
      t = Tag.find_or_create_by_tag(uploader_name)
      t.taggings.create(:photo=>self)
    end
  end
end
