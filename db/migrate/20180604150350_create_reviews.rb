class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :product
      t.string :nickname
      t.string :review_title
      t.text :review_text, limit: 65000
    end

    # add_index :reviews,
    #          [:product_id, :review],
    #          name:   "index_reviews_on_product_id_and_review",
    #          length: {review: 100},
    #          unique: true
  end
end
