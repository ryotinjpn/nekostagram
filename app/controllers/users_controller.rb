class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :edit, :update, :destroy, :following, :followers]

    def index
      if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
        @q = User.ransack(search_params, activated_true: true)
        @title = "Search Result"
      else
        @q = User.ransack(activated_true: true)
        @title = "All users"
      end
        @users = @q.result.paginate(page: params[:page])
    end

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

    def search_params
      params.require(:q).permit(:name_cont)
    end
  
end
