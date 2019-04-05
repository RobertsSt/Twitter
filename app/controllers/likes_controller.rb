class LikesController < ApplicationController
  before_action :set_tweet

  def index
    @likes = Like.where(tweet_id: @tweet.id)
  end

  def create
    @like = Like.new
    @like.tweet_id = @tweet.id
    @like.user_id = current_user.id

    if @like.save
      respond_to do |format|
        format.html { redirect_to root_path(anchor: "tweet_id_#{@tweet.id}") }
        format.js
      end
    else
      flash[:alert] = "Nepareizi uzspiedi like"
      redirect_to root_path
    end
  end

  def destroy
    @like = @tweet.likes.find(params[:id])

    if @like.user_id == current_user.id
     @like.delete
     respond_to do |format|
       format.html { redirect_to root_path }
       format.js
     end
   end
  end

  private


  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end
end