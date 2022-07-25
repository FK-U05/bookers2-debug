class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites,dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(book)
    favorites.exists?(book_id:book.id)
  end

end
