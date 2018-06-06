class GetProduct
  include Interactor

  require 'nokogiri'
  require 'open-uri'

  def call
    puts "We here!!! #{context.inspect}"
    doc = Nokogiri::HTML(open(context.link))
    context.product_id = context.link[/\d+$/,0]

    context.title = doc.css('h1.prod-ProductTitle div').first.content
    context.price = doc.css('span.price-characteristic').first.attribute("content").value
    context.doc = doc

    # begin
      # Product.create!(id:    context.product_id,
      #                 title: context.title,
      #                 price: context.price)
      context.product = Product.where(id: context.product_id).first_or_create do |p|
        p.title = context.title,
        p.price = context.price
      end
    # rescue ActiveRecord::RecordNotUnique
    #   # context.fail!(message: "db.record_not_unique")
    #   Rails.logger.debug 'Product already exists in DB.'
    # end
  end
end
