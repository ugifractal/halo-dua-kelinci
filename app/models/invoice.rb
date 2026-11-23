class Invoice < ApplicationRecord
  belongs_to :brand
  belongs_to :region

  scope :by_region, ->(region_id) { where(region_id: region_id) if region_id.present? }
  scope :by_brand, ->(brand_id) { where(brand_id: brand_id) if brand_id.present? }
end
