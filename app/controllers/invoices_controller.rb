class InvoicesController < ApplicationController
  def index
    @regions = Region.order(:name)
    @brands = Brand.order(:name)

    @invoices = Invoice.includes(:region, :brand)
                       .by_region(params[:region_id])
                       .by_brand(params[:brand_id])
                       .order(date: :desc, invoice_no: :asc)
                       .paginate(page: params[:page], per_page: 30)
  end
end
