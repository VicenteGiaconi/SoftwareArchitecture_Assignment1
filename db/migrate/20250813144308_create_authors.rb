class CreateAuthors < ActiveRecord::Migration[8.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.date :date_of_birth
      t.string :country_of_origin
      t.text :short_description

      t.timestamps
    end
  end
end
