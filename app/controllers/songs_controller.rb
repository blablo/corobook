class SongsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :live]
  before_action :check_user_has_group, only: [:new, :create]
  load_and_authorize_resource
  
  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.order(:title)
    @songbook = Songbook.last

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @song }
    end
  end

  def live
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
      format.json { render json: @song }
    end
  end


  # GET /songs/new
  # GET /songs/new.json
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(params[:song])
    @song.user = current_user
    # If user has a primary group, use it; otherwise use their first group from user_groups
    @song.group = current_user.group || current_user.groups.first

    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render json: @song, status: :created, location: @song }
      else
        format.html { render action: "new" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.json
  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  def songbook_add
    
    sbsong = SongbookSong.new
    sbsong.song_id = params[:song_id]
    sbsong.songbook_id = params[:songbook_id]

    if sbsong.save
      respond_to do |format|
        format.js { render :js => "$('#song" + params[:song_id] + " .add_song').hide(); $('#song" + params[:song_id] + " .remove_song').show();" }
      end
    end
  end
  def songbook_remove

    sbsong = SongbookSong.where("songbook_id = ? and song_id = ?", params[:songbook_id], params[:song_id]).first



    if sbsong.destroy
      respond_to do |format|

        format.js { render :js => "$('#song" + params[:song_id] + " .add_song').show(); $('#song" + params[:song_id] + " .remove_song').hide();" }
      end
    end
  end



  def vote_add
    
    vote = current_user.votes.build
    vote.song_id = params[:song_id]
    if vote.save
      @votes = vote.song.votes.count
      respond_to do |format|
        format.js { render :js => "$('.song#{vote.song_id} .add_vote').next().show(); $('.song#{vote.song_id} .add_vote').hide();$('.song#{vote.song_id} .votes').html('(#{@votes})')" }
      end
    end
  end

  private

  def check_user_has_group
    unless current_user.group || current_user.groups.any?
      redirect_to root_path, alert: 'Debes pertenecer a un grupo para crear canciones. Contacta al administrador.'
    end
  end

end
