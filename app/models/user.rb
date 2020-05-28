class User < ApplicationRecord
  include Gravtastic
          gravtastic
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :microposts, dependent: :destroy
  
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent:   :destroy
  
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :favorite_relationships, dependent: :destroy
  has_many :likes, through: :favorite_relationships, source: :micropost

  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  mount_uploader :image, PictureUploader

  attr_accessor :current_password

   # ユーザーのステータスフィードを返す
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def update_with_password(params, * options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
      update_attributes(params, * options)
  end

  # マイクロポストをライクする
  def like(micropost)
    likes << micropost
  end

  # マイクロポストをライク解除する
  def unlike(micropost)
    favorite_relationships.find_by(micropost_id: micropost.id).destroy
  end

  # 現在のユーザーがライクしていたらtrueを返す
  def likes?(micropost)
    likes.include?(micropost)
  end
end
