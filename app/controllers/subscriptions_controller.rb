class SubscriptionsController < ApplicationController
  
  def create
    if @subscription = Subscription.create(params[:subscription])
      redirect_to(:back)
    end
  end
  
end
