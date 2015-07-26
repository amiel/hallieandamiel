class TagsController < ApplicationController

  CATEGORY_SORT_MAP = { nil => 1, 'user' => 0, 'person' => 2 }

  def index
    if params[:photo_id] then
      @tags = Photo.find(params[:photo_id]).tags
    elsif params[:term] then
      @tags = Tag.where(['tag like ?', params[:term] + '%'])
    else
      @tags = Tag.all
    end

    @categories = @tags.group_by(&:category).sort_by { |category, tags|
      CATEGORY_SORT_MAP[category]
    }

    session[:most_recent_tag] = nil

    respond_to do |format|
      format.html {}
      format.json { render :json => @tags.collect(&:tag) }
    end
  end

  def show
    @tag = Tag.find(params[:id])
    @photos = @tag.photos.approved.page(params[:page] || 1).per(42)

    session[:most_recent_tag] = @tag.id
  end

  def create
    @tag = Tag.find_or_create_by_tag(params[:tag][:tag]) # BIG BUG: case-insensitive

    if params[:photo_id] then
      @photo = Photo.find(params[:photo_id])
      @tagging = Tagging.create({
        :tag => @tag,
        :photo => @photo,
      })

      redirect_to @photo
    else
      redirect_to tags_path
    end
  end

end
