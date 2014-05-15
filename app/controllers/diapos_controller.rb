class DiaposController < ApplicationController


  # GET /diapos
  # GET /diapos.json
  def index
    @diapos = Diapo.order(:title)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @diapos }
    end
  end

  # GET /diapos/1
  # GET /diapos/1.json
  def show
    @diapo = Diapo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @diapo }
    end
  end


  # GET /diapos/new
  # GET /diapos/new.json
  def new
    @diapo = Diapo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @diapo }
    end
  end

  # GET /diapos/1/edit
  def edit
    @diapo = Diapo.find(params[:id])
  end

  # POST /diapos
  # POST /diapos.json
  def create
    @diapo = Diapo.new(params[:diapo])

    respond_to do |format|
      if @diapo.save
        format.html { redirect_to @diapo, notice: 'Diapo was successfully created.' }
        format.json { render json: @diapo, status: :created, location: @diapo }
      else
        format.html { render action: "new" }
        format.json { render json: @diapo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /diapos/1
  # PUT /diapos/1.json
  def update
    @diapo = Diapo.find(params[:id])

    respond_to do |format|
      if @diapo.update_attributes(params[:diapo])
        format.html { redirect_to @diapo, notice: 'Diapo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @diapo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diapos/1
  # DELETE /diapos/1.json
  def destroy
    @diapo = Diapo.find(params[:id])
    @diapo.destroy

    respond_to do |format|
      format.html { redirect_to diapos_url }
      format.json { head :no_content }
    end
  end

  def diapobook_add
    
    sbdiapo = DiapobookDiapo.new
    sbdiapo.diapo_id = params[:diapo_id]
    sbdiapo.diapobook_id = params[:diapobook_id]

    if sbdiapo.save
      respond_to do |format|
        format.js { render :js => "$('#diapo" + params[:diapo_id] + " .add_diapo').hide(); $('#diapo" + params[:diapo_id] + " .remove_diapo').show();" }
      end
    end
  end
  def diapobook_remove

    sbdiapo = DiapobookDiapo.where("diapobook_id = ? and diapo_id = ?", params[:diapobook_id], params[:diapo_id]).first



    if sbdiapo.destroy
      respond_to do |format|

        format.js { render :js => "$('#diapo" + params[:diapo_id] + " .add_diapo').show(); $('#diapo" + params[:diapo_id] + " .remove_diapo').hide();" }
      end
    end
  end



  def vote_add
    
    vote = current_user.votes.build
    vote.diapo_id = params[:diapo_id]
    if vote.save
      @votes = vote.diapo.votes.count
      respond_to do |format|
        format.js { render :js => "$('.diapo#{vote.diapo_id} .add_vote').next().show(); $('.diapo#{vote.diapo_id} .add_vote').hide();$('.diapo#{vote.diapo_id} .votes').html('(#{@votes})')" }
      end
    end
  end


end

