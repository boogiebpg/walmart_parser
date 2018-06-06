class GetProduct
  include Interactor

  require 'nokogiri'
  require 'open-uri'

  def call
    doc = Nokogiri::HTML(open(context.link))
    context.product_id = context.link[/\d+$/,0]

    context.doc   = doc
    context.title = doc.css('h1.prod-ProductTitle div').first.content
    context.price = doc.css('span.price-characteristic').first.attribute('content').value

    context.product = Product.where(id: context.product_id).first_or_create do |p|
      p.title = context.title,
      p.price = context.price
    end
  end
end
