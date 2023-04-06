require 'rails_helper'

RSpec.describe '/admin/shelters/:id', type: :feature do
  let!(:shelter_1) { Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9) }
  let!(:shelter_2) { Shelter.create!(name: 'Denver shelter', city: 'Denver, CO', foster_program: false, rank: 9) }
  let!(:shelter_3) { Shelter.create!(name: 'Boulder shelter', city: 'Boulder, CO', foster_program: false, rank: 9) }

  describe 'When I visit an admin shelter show page' do
    it 'I see the shelters name and full address' do
      visit "/admin/shelters/#{shelter_1.id}"

      expect(page).to have_content('Aurora shelter')
      expect(page).to have_content('Aurora, CO')

    end
  end
end