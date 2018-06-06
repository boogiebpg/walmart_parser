require "rails_helper"

RSpec.describe Review, :type => :model do
  context "few reviews" do
    it "can't insert the same review twice" do
      product = Product.create!(id: '12345', title: 'test', price: '100.00')
      product.reviews.create!(id: '12345', nickname: 'test')
      expect do
        product.reviews.create!(id: '12345', nickname: 'test2')
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
