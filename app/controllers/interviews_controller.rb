class InterviewsController < ApplicationController
  before_action :set_interview, only: [:show, :edit, :update, :destroy]
  before_action :set_user,      only: [:index, :show, :new, :edit, :create, :update, :destroy]
  before_action :correct_user,  only: [:new, :edit, :create, :destroy]

  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = Interview.where(user_id: params[:user_id]).order(:date)
    @scheduled_interview = @interviews.find_by(approval: 1 )
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
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /interviews/1
  # PATCH/PUT /interviews/1.json
  def update
    respond_to do |format|
      if @interview.update(interview_params)
        format.html { redirect_to user_interviews_path(@user), notice: 'Interview was successfully updated.' }
      else
        if @user.id == current_user.id
          format.html { render :edit }
        else
          format.html {
            redirect_to user_interviews_path(@user),
            notice: "The schedule can't be edited because it has already been approved or rejected."
          }
        end
      end
    end
  end

  # DELETE /interviews/1
  # DELETE /interviews/1.json
  def destroy
    respond_to do |format|
      if @interview.destroy
        format.html {
          redirect_to user_interviews_path(@user),
          notice: 'Interview was successfully destroyed.'
        }
      else
        format.html {
          redirect_to user_interviews_path(@user),
          notice: "The schedule can't be edited because it has already been approved or rejected."
        }
      end
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
