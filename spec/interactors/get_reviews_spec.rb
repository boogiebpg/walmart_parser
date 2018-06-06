require "rails_helper"

describe GetReviews do

  describe ".call" do
    context "when given valid args" do
      let(:doc) {'<html>primaryProductId":"test"</html>'}
      let(:product) { Product.create!(title: 'test') }
      let(:context) { GetReviews.call(doc: Nokogiri::HTML(doc), keyword: '', product: product) }
      let(:reviews_response) do
        {payload: {
          reviews: {
            test: {
              customerReviews: [{
                reviewId: 123123,
                reviewTitle: 'Great Product',
                reviewText:  'Works great!',
                userNickname: 'Bill'
              }]
            }
          }
         }
        }.to_json
      end

      before do
        allow_any_instance_of(RestClient::Response).to receive(:body).and_return(reviews_response)
      end

      it "succeeds" do
        expect(context).to be_a_success
      end

    end

    context "problems with parsing" do
      let(:doc) {'<html></html>'}
      let(:context) { GetReviews.call(doc: Nokogiri::HTML(doc)) }

      it "fails" do
        expect(context).to be_a_failure
      end
    end

  end
end
