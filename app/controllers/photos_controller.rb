class PhotosController < ApplicationController
  
  protect_from_forgery :except => [:create]

  def index
    @photos = Photo.page(params[:page] || 1)
  end
  
  def new
    @photo = Photo.new
  end
  
  def show
    @photo = Photo.find(params[:id])
    @tag = @photo.tags.new
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
        @photo = Photo.new(:uploader_name => params[:photo][:uploader_name], :uploader_email => params[:photo][:uploader_email]) # TODO: cookie their infos instead
        render :new
      }
      format.js {
        if @photo.valid? then
          render :text => true.to_json;
        else
          render :text => @photo.errors.full_messages.to_json, :status => '200' # TODO: use a status maybe, but uploadify makes it impossible. :[
        end
      }
    end
  end
  
  def edit
    # TODO: require authentication of some sort
    @photo = Photo.find(params[:photo])
  end
  
  def update
    # TODO: requrie authentication
    @photo = Photo.find(params[:photo])
    
    if @photo.update_attributes(params[:photo]) then
      redirect_to photos_path
    else
      render :edit
    end
  end
  
end
