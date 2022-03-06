class CreateUserposts < ActiveRecord::Migration[7.0]
  def change
    create_table :userposts do |t|
      t.string :name
      t.text :post

      t.timestamps
    end

    create_table :comments do |t|
      t.belongs_to :userpost, index: true, foreign_key: true
      t.text :commentname
      t.text :usercomment

      t.timestamps
    end
  end
end
