defmodule Catcher.Page do

  @derive Jason.Encoder
  defstruct [:page, :per_page, :max_page, :total_pages, :total_count]

  def prepare({data, pagination}) do
    page = %Catcher.Page{
      page: pagination.page,
      per_page: pagination.per_page,
      max_page: pagination.max_page,
      total_pages: pagination.total_pages,
      total_count: pagination.total_count}
    {data, page}
  end
end
