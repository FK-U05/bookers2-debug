class Relationship < ApplicationRecord
  #userだけだとフォローしているユーザーなのかフォローされているユーザーなのかが#
  #わからなくなるのでfollowerとfollowedで分けている。#
  #class_nameで参照するテーブルを置く（このままだとfollowerテーブルとかから持ってきてしまうので#
  #userテーブルを探してもらうため）#
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

end
