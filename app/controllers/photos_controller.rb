class PhotosController < ApplicationController
  USER_NAME, PASSWORD = "amiel", "andhallie"

  before_filter :authenticate, :only => [ :edit, :update, :unapproved ]

  
  protect_from_forgery :except => [:create]

  def index
    @photos = Photo.approved.page(params[:page] || 1).per(30)
  end
  
  def new
    @photo = Photo.new
  end
  
  def show
    @photo = Photo.find(params[:id])
    @tag = @photo.tags.new        
           
    # Set up breadcrumb link back to album
    @breadcrumb_tag = Tag.find(session[:most_recent_tag]) if session[:most_recent_tag]
    session[:most_recent_tag] = nil 
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
    @photos = Photo.unapproved
    render :index
  end
  
  def edit
    @photo = Photo.find(params[:id])
  end
  
  def update
    @photo = Photo.find(params[:id])
    
    if @photo.update_attributes(params[:photo]) then
      redirect_to photos_path
    else
      render :edit
    end
  end

  private
      def authenticate
        authenticate_or_request_with_http_basic do |user_name, password|
          user_name == USER_NAME && password == PASSWORD
        end
      end
end
