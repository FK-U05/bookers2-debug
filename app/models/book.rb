class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  has_many :tagmaps, dependent: :destroy
  has_many :tags, through: :tagmaps

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :latest, -> {order(created_at: :desc)}
  scope :star_count, -> {order(star: :desc)}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
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

  def save_tags(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    new_tags.each do |new|
      book_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << book_tag
    end
  end

end
