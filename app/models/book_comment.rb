class BookComment < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :book_comment,presence:true

end
