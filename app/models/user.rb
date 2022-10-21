class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
 devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 has_many :books,dependent: :destroy
 #一人のユーザーは複数のいいねができる
 has_many :favorites,dependent: :destroy
 #一人のユーザーは複数のコメントができる
 has_many :book_comments,dependent: :destroy
 #一人のユーザーは多くのユーザーをフォローできる
 has_many :relationships, class_name: "Relationship",foreign_key: "follower_id", dependent: :destroy
 #一人のユーザーは多くのユーザーにフォローされる
 has_many :reverse_of_relationships, class_name: "Relationship",foreign_key: "followed_id", dependent: :destroy
 #自分がフォローしている人を表示
 has_many :followings, through: :relationships, source: :followed
 #自分をフォローしている人を表示
 has_many :followers, through: :reverse_of_relationships, source: :follower

 has_one_attached :profile_image

 validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
 validates :introduction,length:{maximum:50}

 def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
 end

 #フォローした時の処理
 def follow(user_id)
   relationships.create(followed_id: user_id)
 end

 #フォローを外す時の処理
 #フォローしてた相手のidを探して削除する
 def unfollow(user_id)
   relationships.find_by(followed_id: user_id).destroy
 end

 #フォローしているかどうかを判定する
 def following?(user)
   followings.include?(user)
 end

 #検索方法の分岐#
 #送られてきたseachによって分岐させる#
  def self.looks(search, word)
    #perfect_matchは完全一致#
    if search == "perfect_match"
      #nameはusersテーブルのカラム(userの名前を検索するからname)#
      #whereメソッドで該当データを取得する。findとかと同じ？#
      #完全一致以外は#{word}の前後もしくは両方に%を追記することで定義可能#
      @user = User.where("name LIKE?", "#{word}")
      #forward_matchは前方一致#
    elsif search == "forward_match"
      @user = User.where("name LIKE?","%#{word}%")
      #backward_matchは後方一致#
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}%")
      #partial_matchは部分一致#
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end
