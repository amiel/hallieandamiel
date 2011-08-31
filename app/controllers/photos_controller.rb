class PhotosController < ApplicationController
  USER_NAME, PASSWORD = "amiel", "andhallie"

  before_filter :authenticate, :only => [ :edit, :unapproved, :duplicates, :destroy ]
  before_filter :find_tag

  protect_from_forgery :except => [:create]

  def index
    @photos = Photo.approved.page(params[:page] || 1).per(42)
  end

  def new
    @photo = Photo.new
  end

  def show
    @photo = Photo.find(params[:id])
    # @tag_for_form = @photo.tags.new

    if @photo
      # Get the next and previous photos in this set
      @photos = (@tag.try(:photos) || Photo).approved.all
      index = @photos.index(@photo)
      if index
        @previous_photo = @photos[index - 1] if index > 0
        @next_photo = @photos[index + 1]
      end
    end
  end

  def create
    @photo = Photo.new(params[:photo])
    @photo.uploader_ip = request.remote_ip

    if @photo.save then
      flash[:notice] = 'Awesome, your photo has been uploaded! Got any more?'
    else
      flash[:notice] = 'Unfortunately, there was a problem uploading that photo.'
    end

    respond_to do |format|
      format.html {
        # This is to pre-populate the next photo upload.
        # Only used when Uploadify horks
        @photo = Photo.new(:uploader_name => params[:photo][:uploader_name], :uploader_email => params[:photo][:uploader_email])
        render :new
      }
      format.js {
        if @photo.valid? then
          render :text => true.to_json;
        else
          render :text => @photo.errors.full_messages.to_json, :status => '200' # BUG: this should be a status, but uploadify makes it impossible. :[
        end
      }
    end
  end

  def unapproved
    @photos = Photo.unapproved.page(params[:page] || 1).per(100)
    render :index
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def duplicates
    counts = Photo.count :group => 'photo_file_name'
    # @duplicates = counts.select { |file_name, count| count > 1 }.
    #               collect { |file_name, count| Photo.all :conditions => { :photo_file_name => file_name } }

    @duplicates = counts.select { |file_name, count| count > 1 }
    @duplicates.each { |file_name, count|
      duplicate = Photo.all :conditions => { :photo_file_name => file_name }

      # Make sure the duplicates have the same file size
      duplicate = duplicate.select { |d| d.photo_file_size == duplicate.first.photo_file_size }
      next if duplicate.size < 2

      @duplicate = duplicate
    }
  end

  def update
    @photo = Photo.find(params[:id])

    if @photo.update_attributes(params[:photo]) then
      redirect_to @photo
    else
      render :edit
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo.update_attribute :deleted_at, Time.current
      flash[:notice] = "Deleted photo ##{ params[:id] }"
    else
      flash[:notice] = "Sorry, not saved: #{ @photo.errors.full_messages.join ', ' }"
    end
    redirect_to action: :duplicates
  end

  private
      def authenticate
        authenticate_or_request_with_http_basic do |user_name, password|
          user_name == USER_NAME && password == PASSWORD
        end
      end

      def find_tag
        @tag = Tag.find(params[:tag_id]) if params[:tag_id]
      end
end
