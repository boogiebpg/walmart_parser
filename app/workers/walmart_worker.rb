class WalmartWorker
  include Sidekiq::Worker

  def perform(parse_form_params)
    ProcessLink.call(parse_form_params)
  end
end
