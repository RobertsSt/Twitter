class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  # GET /tweets
  # GET /tweets.json
  def index
    @current_category = params[:category]
    if @category = Category.find_by(id: @current_category)
      @alltweets = @category.tweets.order("created_at DESC")
    else
      @alltweets = Tweet.preload("user").where(user_id: current_user.followings_as_follower.select("following_user_id")).order("created_at DESC")
    end
    @tweets = @alltweets.page(params[:page]).per(20)
    @tweet = Tweet.new
    @followers = Following.where(following_user: current_user)
    @followings = Following.where(follower_user: current_user)
    @categories = Category.all
    @users = User.all
    @search_id = 1
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @tweets = Tweet.preload("user").where(user_id: current_user.followings_as_follower.select("following_user_id")).order("created_at DESC")
    @followers = Following.where(following_user: current_user)
    @followings = Following.where(follower_user: current_user)
  end

  # GET /tweets/new
  def new
    @tweet = current_user.tweets.build
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = current_user.tweets.build(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to root_path, notice: 'Ieteikums tika veiksmīgi izveidots.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { redirect_to root_path, alert: 'Ieteikums neatbilst formātam (minimālais simbolu skaits - 1, maksimālais simbolu skaits - 420)' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Ieteikums tika veiksmīgi rediģēts.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit, alert: 'Ieteikums neatbilst formātam (minimālais simbolu skaits - 1, maksimālais simbolu skaits - 420)' }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Ieteikums tika veiksmīgi izdzēsts.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:image, :tweet, :category_id)
    end
end
