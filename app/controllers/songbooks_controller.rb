class SongbooksController < ApplicationController
  # GET /songbooks
  # GET /songbooks.json
  def index
    @songbooks = Songbook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @songbooks }
    end
  end

  # GET /songbooks/1
  # GET /songbooks/1.json
  def show
    @songbook = Songbook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @songbook }
    end
  end

  
  def send_email
    @songbook = Songbook.find(params[:id])

    current_user.group.users.each do |user|
      UserMailer.send_songbook(@songbook, user).deliver
    end

    
    respond_to do |format|
      format.html # new.html.erb
      format.js { render :js => "alert('enviado');" }
    end
  end

  # GET /songbooks/new
  # GET /songbooks/new.json
  def new
    @songbook = Songbook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @songbook }
    end
  end

  # GET /songbooks/1/edit
  def edit
    @songbook = Songbook.find(params[:id])
  end

  # POST /songbooks
  # POST /songbooks.json
  def create
    @songbook = Songbook.new(params[:songbook])

    respond_to do |format|
      if @songbook.save
        format.html { redirect_to @songbook, notice: 'Songbook was successfully created.' }
        format.json { render json: @songbook, status: :created, location: @songbook }
      else
        format.html { render action: "new" }
        format.json { render json: @songbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /songbooks/1
  # PUT /songbooks/1.json
  def update
    @songbook = Songbook.find(params[:id])

    respond_to do |format|
      if @songbook.update_attributes(params[:songbook])
        format.html { redirect_to @songbook, notice: 'Songbook was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @songbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songbooks/1
  # DELETE /songbooks/1.json
  def destroy
    @songbook = Songbook.find(params[:id])
    @songbook.destroy

    respond_to do |format|
      format.html { redirect_to songbooks_url }
      format.json { head :no_content }
    end
  end
end
