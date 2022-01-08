class Book < ApplicationRecord
   belongs_to :user

    validates :title, presence: true
    validates :body, presence: true, length: { maximum: 200}
    has_many :favorites, dependent: :destroy
    # has_many throughは中間テーブルの際に使う記述
    has_many :favorited_users, through: :favorites, source: :user
    has_many :book_comments, dependent: :destroy

    def favorited_by?(user)
      favorites.where(user_id: user.id).exists?
    end
    # 完全一致
    def self.search_for(content, method)
      if method == 'perfect'
        Book.where(title: content)
        # 前方一致　モデル名.where('カラム名 like ?','検索したい文字列%')
      elsif method == 'forward'
        Book.where('title LIKE ?', content+'%')
        # 後方一致
      elsif method == 'backward'
        Book.where('title LIKE ?', '%'+content)
        # 部分一致
      else
        Book.where('title LIKE ?', '%'+content+'%')
      end
    end

end
