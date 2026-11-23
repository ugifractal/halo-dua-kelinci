require "csv"
require "date"

namespace :invoices do
  desc "Hapus semua data invoice/region/brand lalu import ulang dari CSV"
  task :import_csv, [ :path ] => :environment do |_task, args|
    path = args[:path].presence || ENV["CSV_PATH"].presence || Rails.root.join("db/csv/invoices.csv").to_s
    abort "File CSV tidak ditemukan: #{path}" unless File.file?(path)

    region_aliases = {
      "jabodetabek" => "Jabodetabek",
      "jabar" => "Jawa Barat",
      "jawa barat" => "Jawa Barat",
      "jawa tengah" => "Jawa Tengah",
      "jawa timur" => "Jawa Timur",
      "kalimantan" => "Kalimantan",
      "sumatera" => "Sumatera"
    }.freeze

    text = ->(value) { value.to_s.strip.presence }
    integer = lambda do |value|
      stripped = value.to_s.strip
      stripped.empty? ? nil : Integer(stripped, 10)
    end

    reset_primary_keys = lambda do
      connection = ActiveRecord::Base.connection
      sequence_exists = connection.select_value(
        "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'sqlite_sequence'"
      )
      return unless sequence_exists

      [ Invoice, Region, Brand ].each do |model|
        connection.execute("DELETE FROM sqlite_sequence WHERE name = #{connection.quote(model.table_name)}")
      end
    end

    brand_ids = {}
    region_ids = {}
    records = []
    blank_salesman = 0
    line = 1
    deleted = {}

    ActiveRecord::Base.transaction do
      deleted[:invoices] = Invoice.delete_all
      deleted[:regions] = Region.delete_all
      deleted[:brands] = Brand.delete_all
      reset_primary_keys.call

      CSV.foreach(path, headers: true, header_converters: :symbol, encoding: "bom|utf-8") do |row|
        line += 1

        region_name = region_aliases[row[:region].to_s.strip.downcase]
        raise ArgumentError, "Baris #{line}: region '#{row[:region]}' tidak dikenal" unless region_name

        brand_name = text.call(row[:brand])
        raise ArgumentError, "Baris #{line}: brand kosong" unless brand_name

        region_id = region_ids[region_name] ||= Region.find_or_create_by!(name: region_name).id
        brand_id = brand_ids[brand_name] ||= Brand.find_or_create_by!(name: brand_name).id

        blank_salesman += 1 if row[:salesman].to_s.strip.empty?

        records << {
          date: Date.iso8601(row[:date].to_s.strip),
          invoice_no: text.call(row[:invoice_no]),
          region_id: region_id,
          brand_id: brand_id,
          branch: text.call(row[:branch]),
          outlet_id: text.call(row[:outlet_id]),
          outlet_name: text.call(row[:outlet_name]),
          outlet_type: text.call(row[:outlet_type]),
          salesman: text.call(row[:salesman]),
          sku: text.call(row[:sku]),
          qty_carton: integer.call(row[:qty_carton]),
          price_per_carton_idr: integer.call(row[:price_per_carton_idr]),
          gross_sales_idr: integer.call(row[:gross_sales_idr]),
          discount_idr: integer.call(row[:discount_idr]),
          net_sales_idr: integer.call(row[:net_sales_idr])
        }
      end

      records.each_slice(500) { |batch| Invoice.insert_all!(batch) }
    end

    puts "Import selesai:"
    puts "- Dihapus: #{deleted[:invoices]} invoices, #{deleted[:regions]} regions, #{deleted[:brands]} brands"
    puts "- Diimpor: #{records.size} invoices, #{brand_ids.size} brands, #{region_ids.size} regions"
    puts "- Salesman kosong: #{blank_salesman} baris (disimpan NULL)"
  rescue StandardError => e
    abort "Import gagal, perubahan di-rollback: #{e.message}"
  end
end
