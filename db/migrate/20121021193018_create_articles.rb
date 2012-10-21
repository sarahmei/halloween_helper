class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.integer :id
      t.string :title
      t.integer :number_of_votes, :default => 0
    end
  end

  def down
    drop_table :articles
  end
end