require "rails_helper"

describe GetProduct do
  subject(:context) { GetProduct.call(link: 'http://walmart.com/test', keyword: '') }

  describe ".call" do
    context "when given valid args" do
      let(:doc) do
        '<html>
           <h1 class="prod-ProductTitle">
             <div>Title</div>
           </h1>
           <span class="price-characteristic" content="100.99">
           </span>
         </html>'
      end

      before do
        allow_any_instance_of(GetProduct).to receive(:get_html).and_return(doc)
      end

      it "succeeds" do
        expect(context).to be_a_success
      end

      it "provides the title" do
        expect(context.title).to eq('Title')
      end

      it "provides the price" do
        expect(context.price).to eq('100.99')
      end

    end

    context "problems with parsing" do
      let(:incorrect_doc) { '<html></html>' }

      before do
        allow_any_instance_of(GetProduct).to receive(:get_html).and_return(incorrect_doc)
      end

      it "fails" do
        expect(context).to be_a_failure
      end
    end

    context "when given invalid credentials" do
      before do
        allow_any_instance_of(GetProduct).to receive(:get_html).and_return(nil)
      end

      it "fails" do
        expect(context).to be_a_failure
      end

      it "provides a failure message" do
        expect(context.message).to be_present
      end
    end
  end
end
