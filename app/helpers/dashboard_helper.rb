module DashboardHelper
  def weakest_outlets_summary_text(outlets)
    return "Belum ada data invoice untuk dirangkum." if outlets.blank?

    rows = outlets.each_with_index.map do |outlet, index|
      net_sales = number_to_currency(outlet.total_net_sales, unit: "Rp ", delimiter: ".", precision: 0)
      "#{index + 1}. #{outlet.outlet_name} — #{net_sales}"
    end

    [
      "Yth. Sales Manager,",
      "",
      "Berikut 5 outlet dengan total net sales terendah berdasarkan data penjualan terbaru:",
      "",
      *rows,
      "",
      "Mohon perhatian dan tindak lanjut untuk meningkatkan penjualan pada outlet-outlet tersebut.",
      "",
      "Terima kasih."
    ].join("\n")
  end
end
