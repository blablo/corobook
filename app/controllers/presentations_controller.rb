class PresentationsController < ApplicationController

  # GET /presentations
  # GET /presentations.json
  def index
    @presentations = current_church.presentations.order('fecha desc').page params[:page]

  end

  # GET /presentations/1
  # GET /presentations/1.json
  def show
    @presentation = current_church.presentations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @presentation }
    end
  end

  # GET /presentations/1
  # GET /presentations/1.json
  def live
    @presentation = current_church.presentations.find(params[:id])
    @anniversaries = current_church.anniversaries

    respond_to do |format|
      format.html { render :layout => false } # show.html.erb
      format.json { render json: @presentation }
    end
  end

  # GET /presentations/new
  # GET /presentations/new.json
  def new
    @presentation = current_church.presentations.build
    @presentation.load_template(current_church)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @presentation }
    end
  end

  # GET /presentations/1/edit
  def edit
    @presentation = current_church.presentations.find(params[:id])
  end

  # POST /presentations
  # POST /presentations.json
  def create
    @presentation = current_church.presentations.build(params[:presentation])

    respond_to do |format|
      if @presentation.save
        format.html { redirect_to @presentation, notice: 'Presentation was successfully created.' }
        format.json { render json: @presentation, status: :created, location: @presentation }
      else
        format.html { render action: "new" }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /presentations/1
  # PUT /presentations/1.json
  def update
    @presentation = current_church.presentations.find(params[:id])

    respond_to do |format|
      if @presentation.update_attributes(params[:presentation])
        format.html { redirect_to @presentation, notice: 'Presentation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @presentation = current_church.presentations.find(params[:id])
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to presentations_url }
      format.json { head :no_content }
    end
  end

  def presentationbook_add
    
    sbpresentation = PresentationbookPresentation.new
    sbpresentation.presentation_id = params[:presentation_id]
    sbpresentation.presentationbook_id = params[:presentationbook_id]

    if sbpresentation.save
      respond_to do |format|
        format.js { render :js => "$('#presentation" + params[:presentation_id] + " .add_presentation').hide(); $('#presentation" + params[:presentation_id] + " .remove_presentation').show();" }
      end
    end
  end
  def presentationbook_remove

    sbpresentation = PresentationbookPresentation.where("presentationbook_id = ? and presentation_id = ?", params[:presentationbook_id], params[:presentation_id]).first



    if sbpresentation.destroy
      respond_to do |format|

        format.js { render :js => "$('#presentation" + params[:presentation_id] + " .add_presentation').show(); $('#presentation" + params[:presentation_id] + " .remove_presentation').hide();" }
      end
    end
  end



  def vote_add
    
    vote = current_user.votes.build
    vote.presentation_id = params[:presentation_id]
    if vote.save
      @votes = vote.presentation.votes.count
      respond_to do |format|
        format.js { render :js => "$('.presentation#{vote.presentation_id} .add_vote').next().show(); $('.presentation#{vote.presentation_id} .add_vote').hide();$('.presentation#{vote.presentation_id} .votes').html('(#{@votes})')" }
      end
    end
  end


end
