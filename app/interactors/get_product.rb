class GetProduct
  include Interactor

  require 'nokogiri'
  require 'open-uri'
  require 'rest-client'

  def get_html url
    begin
      response = RestClient.get url
      response.body
    rescue SocketError
      nil
    end
  end

  def call
    page_content = get_html(context.link)
    context.fail!(message: "get_link.failure") && exit if page_content.nil?

    doc = Nokogiri::HTML(page_content)
    context.product_id = context.link[/\d+$/,0]

    begin
      context.doc   = doc
      context.title = doc.css('h1.prod-ProductTitle div').first.content
      context.price = doc.css('span.price-characteristic').first.attribute('content').value
    rescue NoMethodError
      context.fail!(message: "parse_page.failure") && exit
    end

    context.product = Product.where(id: context.product_id).first_or_create do |p|
      p.title = context.title,
      p.price = context.price
    end
  end
end
