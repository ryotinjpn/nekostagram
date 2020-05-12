class User < ApplicationRecord
  include Gravtastic
          gravtastic
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :microposts, dependent: :destroy

   # 完全な実装は次章の「ユーザーをフォローする」を参照
   def feed
    Micropost.where("user_id = ?", id)
  end
end
