class DashboardController < ApplicationController
  def index
    @weakest_outlets = Invoice
                       .select(
                         "outlet_id",
                         "outlet_name",
                         "SUM(net_sales_idr) AS total_net_sales",
                         "COUNT(*) AS invoice_count"
                       )
                       .group(:outlet_id, :outlet_name)
                       .order(Arel.sql("SUM(net_sales_idr) ASC"))
                       .limit(5)
  end
end
