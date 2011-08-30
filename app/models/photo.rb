class Photo < ActiveRecord::Base
  default_scope where(:deleted_at => nil)

  paginates_per 10

  has_many :taggings
  has_many :tags, :through => :taggings

  has_attached_file :photo, :styles => { :full => "900x960>", :thumbnail => "100x100#" },
    :storage => :s3,
    :s3_credentials => Rails.root.join('config/paperclip.yml'),
    :s3_headers => {'Expires' => 1.year.from_now.httpdate }

  scope :approved, where(:approved => true)
  scope :unapproved, where(:approved => false)

  after_create :tag_uploader

  validates_presence_of :photo
  validates_format_of :uploader_email, :with => /^\w(\.?[\w-])*@\w(\.?[\w-])*\.[a-z]{2,6}$/i, :allow_blank => true

  def sanitized_uploader_name
    if (uploader_name.match(/(.* \w)/)) then
      $1 + '.'
    else
      uploader_name
    end
  end

  def tag_uploader
    if uploader_name and not uploader_name.blank? then
      t = Tag.find_or_create_by_tag_and_category(sanitized_uploader_name, 'user')
      t.taggings.create(:photo=>self)
    end
  end
end
