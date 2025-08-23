class Hotel < ApplicationRecord
  belongs_to :trip
  
  validates :name, presence: true
  validates :url, presence: true, format: { with: URI::regexp, message: "must be a valid URL" }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true, length: { is: 3 }
end
