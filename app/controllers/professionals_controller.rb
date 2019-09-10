class ProfessionalsController < ApplicationController
  def index
  end
  def new
  	@professional = Professional.new
  end

  def create
  	@professional = Professional.new(professional_params)
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
        :customer_id)
    end
end
