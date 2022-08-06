class Tag < ApplicationRecord

  has_many :tagmaps, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :tagmaps

 def self.looks(search, word)
  if search == 'perfect'
   tags = Tag.where(tag_name: word)
  elsif search == 'forward'
   tags = Tag.where('tag_name LIKE?',"#{word}")
  elsif search == 'backward'
   tags = Tag.where("tag_name LIKE?","%#{word}%")
  else
   tags = Tag.where("tag_name LIKE?","%#{word}%")
  end
  return tags.inject(init =[]) {|result,tag| result + tag.books}
 end

end
