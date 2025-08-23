# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample trips
puts "Creating sample trips..."

trip1 = Trip.create!(
  country: "France",
  start_date: Date.new(2024, 6, 15),
  end_date: Date.new(2024, 6, 22),
  description: "Exploring Paris and the French countryside"
)

trip2 = Trip.create!(
  country: "Japan",
  start_date: Date.new(2024, 9, 1),
  end_date: Date.new(2024, 9, 10),
  description: "Tokyo and Kyoto adventure"
)

trip3 = Trip.create!(
  country: "Australia",
  start_date: Date.new(2024, 12, 20),
  end_date: Date.new(2025, 1, 5),
  description: "Sydney and Great Barrier Reef vacation"
)

# Create sample hotels for each trip
puts "Creating sample hotels..."

# Hotels for France trip
trip1.hotels.create!([
  {
    name: "Hotel de Paris",
    url: "https://booking.com/hotel/paris-de-paris",
    price: 250.00,
    currency: "EUR"
  },
  {
    name: "Le Grand Hotel",
    url: "https://booking.com/hotel/paris-grand",
    price: 180.00,
    currency: "EUR"
  },
  {
    name: "Charming Airbnb",
    url: "https://airbnb.com/rooms/12345",
    price: 120.00,
    currency: "EUR"
  }
])

# Hotels for Japan trip
trip2.hotels.create!([
  {
    name: "Tokyo Hilton",
    url: "https://booking.com/hotel/tokyo-hilton",
    price: 300.00,
    currency: "USD"
  },
  {
    name: "Kyoto Traditional Inn",
    url: "https://booking.com/hotel/kyoto-ryokan",
    price: 200.00,
    currency: "USD"
  }
])

# Hotels for Australia trip
trip3.hotels.create!([
  {
    name: "Sydney Harbour Hotel",
    url: "https://booking.com/hotel/sydney-harbour",
    price: 350.00,
    currency: "AUD"
  },
  {
    name: "Cairns Resort",
    url: "https://booking.com/hotel/cairns-resort",
    price: 280.00,
    currency: "AUD"
  }
])

puts "Sample data created successfully!"
puts "Created #{Trip.count} trips and #{Hotel.count} hotels"
