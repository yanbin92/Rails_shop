class CreateLegacyBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :legacy_books do |t|

      t.timestamps
    end
  end
end
