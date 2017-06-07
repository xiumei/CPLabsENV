class ApiController < ActionController::Base
  protect_from_forgery
  def get_foo

    @response = { :foo => "bar" }
    respond_to do |format|
      format.xml  { render xml: @response }
      format.json { render json: @response }
    end
  end
end
