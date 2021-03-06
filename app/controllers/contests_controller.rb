class ContestsController < ApplicationController
  before_action :find_contest, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :filter]

  def new_featured
    @contest = Contest.new
  end

  def new
    @contest = Contest.new
  end

  def create
    @contest          = Contest.new contest_params
    @contest.user     = current_user
    @contest.end_date = DateTime.now + params[:contest][:end_date].to_i.days
    if @contest.save
      redirect_to customer_contests_path, notice: "Contest created successfully!"
    else
      flash[:alert] = "There is a problem!"
      render :new
    end
  end

  def show
    @entry = Entry.new
    respond_to do |format|
      format.html { render }
      format.json { render json: @contest.to_json }
      format.xml  { render xml: @contest.to_xml }
    end
  end

  def index
    @contest = Contest.all.order("end_date DESC")
  end

  def edit
  end

  def update
    @contest          = Contest.new contest_params
    @contest.user     = current_user
    @contest.end_date = DateTime.now + params[:contest][:end_date].to_i.days
    if @contest.update contest_params
      redirect_to customer_contests_path, notice: "Contest created successfully!"
    else
      render :edit
    end
  end

  def destroy
    @contest.destroy
    redirect_to contests_path
  end

  def publish
    @contest = Contest.find params[:contest_id]
    @contest.update(published: true)
    if @contest.save
      redirect_to customer_contests_path, notice: "Published!"
    else
      flash[:alert] = "Problem!"
      render @contest
    end
  end

  private

  def contest_params
    contest_params = params.require(:contest).permit(:title, :body, :image, :prize, :end_date, :featured, :category_id, :published, :user_id, {image:[]})
  end

  def find_contest
    @contest = Contest.find params[:id]
  end

end
