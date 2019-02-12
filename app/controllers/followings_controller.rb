class FollowingsController < ApplicationController
  def index
    @users = Tweet.all
    @followings = Following.where(follower_user: current_user)
    @follow = true
  end
end
