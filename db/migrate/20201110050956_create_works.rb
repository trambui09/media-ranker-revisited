class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.string :title
      t.string :creator
      t.string :description
      t.string :category
      t.integer :vote_count, default: 0
      t.integer :publication_year, default: 1900

      t.timestamps
    end
  end
end
