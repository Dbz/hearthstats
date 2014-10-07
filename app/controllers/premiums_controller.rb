class PremiumsController < ApplicationController
  before_filter :ssl_page
  def index
    if current_user.nil?
      redirect_to new_user_registration_path, alert: "You must sign up before purchasing premium subscription"
    end
  end

  def new
  end

  def create
    @amount = 499
    begin
      if current_user.customer_id.nil?
        customer = Stripe::Customer.create(
          email: current_user.email,
          card: params[:stripeToken],
          plan: "early"
        )
        current_user.subscription_id = 1
        current_user.customer_id = customer.id
        current_user.save!
        current_user.add_role :early_sub
      else
        customer = Stripe::Customer.retrieve(current_user.customer_id)
        if params[:stripeToken].present?
          customer.card = params[:stripeToken]
        end
        current_user.subscription_id = 1
        customer.plan = "early"
        current_user.add_role :early_sub
        current_user.save
        customer.save
      end
    rescue Stripe::CardError => e
    end
    redirect_to premiums_path, alert: e

  end

  def show
  end

  def cancel
    begin
      customer = Stripe::Customer.retrieve(current_user.customer_id)
      unless customer.nil? || customer.respond_to?("deleted")
        subscription = customer.subscriptions.data[0]
        if subscription.status == "active"
          customer.cancel_subscription
          current_user.subscription_id = nil
          current_user.remove_role :early_sub
          current_user.save!
        end
      end
    rescue Stripe::CardError => e
    end
    redirect_to premiums_path
  end

  def ssl_page
    if Rails.env.production? 
      redirect_to :protocol => 'https://'
    end
  end
end
