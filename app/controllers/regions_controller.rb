class RegionsController < ApplicationController
  def index
    @regions = Region.order(:name)
  end

  def show
    @region = Region.find(params[:id])
    @invoices = Invoice.includes(:region, :brand)
                       .where(region: @region)
                       .order(date: :desc, invoice_no: :asc)
                       .paginate(page: params[:page], per_page: 30)
  end
end
