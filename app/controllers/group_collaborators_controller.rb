class GroupCollaboratorsController < ApplicationController
  # GET /group_collaborators
  # GET /group_collaborators.json
  def index
    @group_collaborators = GroupCollaborator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @group_collaborators }
    end
  end

  # GET /group_collaborators/1
  # GET /group_collaborators/1.json
  def show
    @group_collaborator = GroupCollaborator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group_collaborator }
    end
  end

  # GET /group_collaborators/new
  # GET /group_collaborators/new.json
  def new
    @group_collaborator = GroupCollaborator.new



    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group_collaborator }
    end
  end

  # GET /group_collaborators/1/edit
  def edit
    @group_collaborator = GroupCollaborator.find(params[:id])
  end

  # POST /group_collaborators
  # POST /group_collaborators.json
  def create
    @group_collaborator = GroupCollaborator.new(params[:group_collaborator])


    respond_to do |format|
      if @group_collaborator.save
        if !User.find_by_email(@group_collaborator.email)
          user = User.new({:email => @group_collaborator.email, :name => @group_collaborator.name })
          user.password = 'test1212'
          user.group_id = current_user.group_id
          user.reset_password_token= User.reset_password_token 
          if user.save
            @group_collaborator.update_attribute(:user_id, user.id)
            UserMailer.invited_collaborator(current_user, user).deliver
          end
        end        
        format.html { redirect_to @group_collaborator, notice: 'Group collaborator was successfully created.' }
        format.json { render json: @group_collaborator, status: :created, location: @group_collaborator }
      else
        format.html { render action: "new" }
        format.json { render json: @group_collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /group_collaborators/1
  # PUT /group_collaborators/1.json
  def update
    @group_collaborator = GroupCollaborator.find(params[:id])

    respond_to do |format|
      if @group_collaborator.update_attributes(params[:group_collaborator])
        format.html { redirect_to @group_collaborator, notice: 'Group collaborator was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group_collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_collaborators/1
  # DELETE /group_collaborators/1.json
  def destroy
    @group_collaborator = GroupCollaborator.find(params[:id])
    @group_collaborator.destroy

    respond_to do |format|
      format.html { redirect_to group_collaborators_url }
      format.json { head :no_content }
    end
  end
end
