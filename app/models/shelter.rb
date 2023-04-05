class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :applications, through: :pets

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def with_pending_applications
    if applications.where(status: 'Pending') != nil
      self.name
    end
  end

  def self.find_shelter_name(id)
    find_by_sql("SELECT name FROM shelters WHERE id = #{id}").first[:name]
  end

  def self.find_shelter_address(id)
    find_by_sql("SELECT city FROM shelters WHERE id = #{id}").first[:city]
  end
end
