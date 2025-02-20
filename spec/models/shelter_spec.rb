require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
    it { should have_many(:applications) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#find_shelter_name' do
      it 'returns a shelter by id in raw sql' do
        shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        shelter3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

        expect(Shelter.find_shelter_name(shelter1.id)).to eq('Aurora shelter')
        expect(Shelter.find_shelter_name(shelter3.id)).to eq('Fancy pets of Colorado')
      end
    end

    describe '#find_shelter_address' do
      it 'returns a shelter by id in raw sql' do
        shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        shelter3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

        expect(Shelter.find_shelter_address(shelter1.id)).to eq('Aurora, CO')
        expect(Shelter.find_shelter_address(shelter3.id)).to eq('Denver, CO')
      end
    end
  end

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '.with_pending_applications' do
      it 'returns shelters with pending applications' do
        shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        shelter3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

        pet2 = shelter1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
        pet3 = shelter3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

        application1 = Application.create!(name: 'John Doe', address: '123 Main St', city: 'Denver', state: 'CO', zip: '80202', description: 'I love animals', status: 'Pending')
        application2 = Application.create!(name: 'Jane Doe', address: '123 Main St', city: 'Denver', state: 'CO', zip: '80202', description: 'I love animals', status: 'Pending')

        shelters = [shelter1, shelter3]

        PetApplication.create!(pet: pet2, application: application1)
        PetApplication.create!(pet: pet3, application: application2)

        expect(Shelter.with_pending_applications).to eq(["Aurora shelter", "Fancy pets of Colorado"])
      end
    end
  end
end
