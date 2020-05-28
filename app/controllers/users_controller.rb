class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :edit, :update, :destroy, :following, :followers]

    def index
      if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
        @q = User.ransack(search_params, activated_true: true)
        @title = "検索結果"
      else
        @q = User.ransack(activated_true: true)
        @title = "おすすめ"
      end
        @users = @q.result.paginate(page: params[:page])
    end

    def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(page: params[:page])

        @currentUserEntry=Entry.where(user_id: current_user.id)
        @userEntry=Entry.where(user_id: @user.id)
        if @user.id == current_user.id
        else
          @currentUserEntry.each do |cu|
            @userEntry.each do |u|
              if cu.room_id == u.room_id then
                @isRoom = true
                @roomId = cu.room_id
              end
            end
          end
          if @isRoom
          else
            @room = Room.new
            @entry = Entry.new
          end
        end
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
