require 'stripe'

class ProfessionalsController < ApplicationController
  def index
  end
  def checkout
  end

  def new
    @professional = Professional.new

    if params[:rate] == "Standard"
      prices = '19.99'
    else
      prices = '29.99'
    end

  end

  def create
    @professional = Professional.new(professional_params)
    @professional.customer_id = Stripe::Customer.create({
      source: params[:stripe_token],
      email: @professional.email
    })
    if @professional.save
      redirect_to root_path
    else
      render 'new'
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
        :prices,
        :rate)
    end
end
