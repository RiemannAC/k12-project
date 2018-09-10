class RenameTitleToNameInTopicmodel < ActiveRecord::Migration[5.1]
  def change
    rename_column :topics,:title,:name
  end
end
