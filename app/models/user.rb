class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  # フォローをした、されたの関係
  has_many :relationships, class_name:"Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # チャットルームのアソシエーション
  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  attachment :profile_image
  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50}

  # フォローしたときの処理
  def follow(user_id)
  relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end
  def self.search_for(content, method)
    if method == 'perfect'
       User.where(name: content)
      # 前方一致　モデル名.where('カラム名 like ?','検索したい文字列%')→Userモデルのnameカラムの文字列データのどこかにcontent+(前方一致)と含まれているレコードを取得という意味
    elsif method == 'forward'
      User.where('name LIKE ?', content+'%')
      # 後方一致
    elsif method == 'backward'
      User.where('name LIKE ?', '%'+content)
      # 部分一致
    else
      User.where('name LIKE ?', '%'+content+'%')
    end
  end
end
