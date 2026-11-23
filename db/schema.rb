# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_23_000003) do
  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "invoices", force: :cascade do |t|
    t.date "date", null: false
    t.string "invoice_no", null: false
    t.integer "region_id", null: false
    t.integer "brand_id", null: false
    t.string "branch"
    t.string "outlet_id"
    t.string "outlet_name"
    t.string "outlet_type"
    t.string "salesman"
    t.string "sku"
    t.integer "qty_carton"
    t.integer "price_per_carton_idr"
    t.integer "gross_sales_idr"
    t.integer "discount_idr"
    t.integer "net_sales_idr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_invoices_on_brand_id"
    t.index ["date"], name: "index_invoices_on_date"
    t.index ["invoice_no"], name: "index_invoices_on_invoice_no"
    t.index ["region_id"], name: "index_invoices_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  add_foreign_key "invoices", "brands"
  add_foreign_key "invoices", "regions"
end
