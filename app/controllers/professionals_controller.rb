require 'stripe'

class ProfessionalsController < ApplicationController
  def index
  end
  def new
    @professional = Professional.new
  end

  def create
    @professional = Professional.new(professional_params)
    begin
      @professional.customer_id = Stripe::Customer.create({
        source: params[:stripe_token],
        email: @professional.email
      })
    rescue Stripe::CardError => e
      puts "Status is: #{e.http_status}"
      puts "Type is: #{e.error.type}"
      puts "Charge ID is: #{e.error.charge}"
      # The following fields are optional
      puts "Code is: #{e.error.code}" if e.error.code
      puts "Decline code is: #{e.error.decline_code}" if e.error.decline_code
      puts "Param is: #{e.error.param}" if e.error.param
      puts "Message is: #{e e.error.message}" if e.error.message
    rescue Stripe::RateLimitError => e
      # Too many requests made to the API too quickly
    rescue Stripe::InvalidRequestError => e
      # Invalid parameters were supplied to Stripe's API
    rescue Stripe::AuthenticationError => e
      # Authentication with Stripe's API failed
      # (maybe you changed API keys recently)
    rescue Stripe::APIConnectionError => e
      # Network communication with Stripe failed
    rescue Stripe::StripeError => e
      # Display a very generic error to the user, and maybe send
      # yourself an email
    rescue => e
      # Something else happened, completely unrelated to Stripe
    end
    if @professional.customer_id != nil
      if @professional.save
        redirect_to root_path
      else
        render 'new'
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def professional_params
      params.require(:professional).permit(
        :email, 
        :password,
        :first_name, 
        :last_name,
        :type, 
        :rate)
    end
end
