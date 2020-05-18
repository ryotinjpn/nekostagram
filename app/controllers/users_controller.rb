class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :edit, :update, :destroy, :following, :followers]

    def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(page: params[:page])
    end

    def following
        @title = "フォロー中"
        @user  = User.find(params[:id])
        @users = @user.following.paginate(page: params[:page])
        render 'show_follow'
    end
    
    def followers
        @title = "フォロワー"
        @user  = User.find(params[:id])
        @users = @user.followers.paginate(page: params[:page])
        render 'show_follow'
    end

    def likes
      @title = "Likes"
      @user  = User.find(params[:id])
      @microposts = @user.likes.paginate(page: params[:page])
      render 'show_like'
    end
  
  private
  
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
