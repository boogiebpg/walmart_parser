class GetReviews
  include Interactor

  require 'nokogiri'
  require 'open-uri'
  require 'rest-client'

  REVIEWS_URL = "https://www.walmart.com/terra-firma/fetch?rgs=REVIEWS_MAP"

  def call
    # fetch product_id_hash for comments fetching
    product_id_hash = context.doc.content[/primaryProductId":"(.+?)"/m, 1]
    context.fail!(message: "reviews.cant_find_product_id_hash") if product_id_hash.nil?

    # fetching comments
    reviews_page = 0
    loop do
      reviews_page += 1
      request_body = {productId: product_id_hash,
                      paginationContext: {sort:   "relevancy",
                                          filters: [],
                                          limit:   100,
                                          page:    reviews_page}}.to_json
      response = RestClient.post REVIEWS_URL,
                                 request_body,
                                 {content_type: :json, accept: :json}

      begin
        reviews = JSON.parse(response.body)&.dig('payload',
                                                 'reviews',
                                                 product_id_hash,
                                                 'customerReviews')
      rescue JSON::ParserError
        context.fail!(message: "reviews.response_parse_error")
      end
      reviews.each do |review|
        next if !review['reviewText'].include?(context.keyword) && context.keyword.present?
        begin
          context.product.reviews.create(id:           review['reviewId'],
                                         nickname:     review['userNickname'],
                                         review_title: review['reviewTitle'],
                                         review_text:  review['reviewText'])
        rescue ActiveRecord::RecordNotUnique
          Rails.logger.debug 'Review already exists in DB.'
        end
      end
      reviews_count = reviews.count
      break if reviews_count < 1
    end
  end
end
