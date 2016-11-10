require "migration_helpers"
class CreateLineItems < ActiveRecord::Migration[5.0]
  extend MigrationHelpers
  def change
    create_table :line_items do |t|
      t.references :product, foreign_key: true
      t.belongs_to :cart, foreign_key: true

      t.timestamps
    end
    #
	# foreign_key(:line_items, :product_id, :products)
	# foreign_key(:line_items, :order_id, :orders)


  end

end
