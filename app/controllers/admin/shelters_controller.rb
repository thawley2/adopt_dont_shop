class Admin::SheltersController < ApplicationController
  
  def index
    @shelters = Shelter.find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end

  def show
    @shelter_name = Shelter.find_shelter_name(params[:id])
    @shelter_address = Shelter.find_shelter_address(params[:id])
  end
end