class StaticPagesController < ApplicationController
  #before_action :authenticate_user!

  def home
    if user_signed_in?
      @user = current_user.id
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
