require "rails_helper"

RSpec.describe Product, :type => :model do
  context "few products" do
    it "can't insert the same product twice" do
      Product.create!(id: '12345', title: 'test', price: '100.00')
      expect do
        Product.create!(id: '12345', title: 'test2', price: '110.00')
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
