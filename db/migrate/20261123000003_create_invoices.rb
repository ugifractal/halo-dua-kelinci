class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.date :date, null: false
      t.string :invoice_no, null: false
      t.references :region, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.string :branch
      t.string :outlet_id
      t.string :outlet_name
      t.string :outlet_type
      t.string :salesman
      t.string :sku
      t.integer :qty_carton
      t.integer :price_per_carton_idr
      t.integer :gross_sales_idr
      t.integer :discount_idr
      t.integer :net_sales_idr

      t.timestamps
    end

    add_index :invoices, :invoice_no
    add_index :invoices, :date
  end
end
