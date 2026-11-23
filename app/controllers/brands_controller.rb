class BrandsController < ApplicationController
  def index
    @brands = Brand.order(:name)
  end

  def show
    @brand = Brand.find(params[:id])
    @invoices = Invoice.includes(:region, :brand)
                       .where(brand: @brand)
                       .order(date: :desc, invoice_no: :asc)
                       .paginate(page: params[:page], per_page: 30)
  end
end
