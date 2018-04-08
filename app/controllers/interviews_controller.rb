class InterviewsController < ApplicationController
  before_action :set_interview, only: [:show, :edit, :update, :destroy]
  before_action :set_user,      only: [:index, :show, :new, :edit, :create, :update, :destroy]
  before_action :correct_user,  only: [:new, :edit, :create, :destroy]

  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = Interview.where(user_id: params[:user_id])
    @scheduled_interview = Interview.find_by(approval: 1 )
  end

  # GET /interviews/1
  # GET /interviews/1.json
  def show
  end

  # GET /interviews/new
  def new
    @interview = Interview.new
  end

  # GET /interviews/1/edit
  def edit
  end

  # POST /interviews
  # POST /interviews.json
  def create
    @interview = current_user.interviews.new(interview_params)

    respond_to do |format|
      if @interview.save
        format.html { redirect_to user_interviews_path(@user), notice: 'Interview was successfully created.' }
        format.json { render :show, status: :created, location: @interview }
      else
        format.html { render :new }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interviews/1
  # PATCH/PUT /interviews/1.json
  def update
    respond_to do |format|
      if @interview.update(interview_params)
        format.html { redirect_to user_interviews_path(@user), notice: 'Interview was successfully updated.' }
        format.json { render :show, status: :ok, location: @interview }
      else
        format.html { render :edit }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interviews/1
  # DELETE /interviews/1.json
  def destroy
    @interview.destroy
    respond_to do |format|
      format.html { redirect_to user_interviews_url(@user), notice: 'Interview was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_interview
      @interview = Interview.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interview_params
      params.require(:interview).permit(:date, :approval)
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def correct_user
      unless @user.id == current_user.id
        redirect_to(user_interviews_url(@user))
        flash[:notice] = "You can't edit and delete it."
      end
    end
end
