class ProductsController < ApplicationController
  def new
  end

  def create
    WalmartWorker.perform_async(parse_form_params.to_unsafe_h)
  end

  private

  def parse_form_params
    params.require(:parse_form).permit(:link, :keyword)
  end
end
