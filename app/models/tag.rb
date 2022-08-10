class Tag < ApplicationRecord

  has_many :tagmaps, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :tagmaps


 def self.looks(method, word)
   #tag_nameはtagsテーブルのカラム(タグ名を検索するからtag_nameとする)#
   #whereメソッドで該当データを取得する。findとかと同じ？#
  if method == 'perfect'
   @tag = Tag.where("tag_name LIKE?","#{word}")
  end
 end

end
