class Photo < ActiveRecord::Base
  default_scope where(:deleted_at => nil)

  paginates_per 10

  has_many :taggings
  has_many :tags, :through => :taggings

  has_attached_file :photo, :styles => { :full => "900x960>", :thumbnail => "100x100#" },
    :storage => :s3,
    :s3_credentials => {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      bucket: 'mcgeefamilyreunion',
    },
    bucket: 'mcgeefamilyreunion',
    :s3_headers => {'Expires' => 1.year.from_now.httpdate }

  validates_attachment_file_name :photo, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i]

  # validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  # do_not_validate_attachment_file_type :photo

  scope :approved, where(:approved => true)
  scope :unapproved, where(:approved => false)

  after_save :tag_uploader

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
      t.taggings.create(:photo => self) unless tags.include?(t)
    end
  end
end
