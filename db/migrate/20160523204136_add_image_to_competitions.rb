class AddImageToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :image, :string
  end
end
