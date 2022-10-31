class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  has_many :tagmaps, dependent: :destroy
  has_many :tags, through: :tagmaps
  has_many :view_counts, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  #表示順の並び替え#
  #scope機能を使う,scope:スコープ名->{条件式}#
  #latestやstar_countはなんでもいい,任意の名前#
  #orderでデータの取り出し#
  #created_at(投稿日)やstarはカラム名、descは昇順の意味#
  scope :latest, -> {order(created_at: :desc)}
  scope :star_count, -> {order(star: :desc)}

  #favoriteテーブルにuserが存在していればいいねを解除する、存在しなければいいねする#
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

#検索方法の分岐#
#送られてきたseachによって分岐させる#

  def self.looks(search, word)
      #titleはbooksテーブルのカラム(bookのタイトルを検索するからtitle)#
      #whereメソッドで該当データを取得する。findとかと同じ？#
      #完全一致以外は#{word}の前後もしくは両方に%を追記することで定義可能#
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","%#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}%")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  #タグを保存する#
  #()内は自由#
  def save_tags(sent_tags)
    #現在あるタグを取得する。,tag_nameはカラム名#
    #pluckメソッドはモデル名.pluck（:カラム名)と使う#
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    #現在あるタグ全てから今送った新しいタグを引いて既にあった古いタグとする。#
    #sent_tagsは上の（）内のやつを使っている。#
    old_tags = current_tags - sent_tags
    #今回保存されたタグと現在存在するタグの差を新しいタグとする。#
    new_tags = sent_tags - current_tags
    #古いタグは消す#
    #find_byの()内はカラム名：||変数の中身#
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end
    #新しいタグを保存#
    new_tags.each do |new|
      book_tag = Tag.find_or_create_by(tag_name: new)
    #配列に保存#
      self.tags << book_tag
    end
  end

end
