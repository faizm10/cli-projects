class Trip < ApplicationRecord
  has_many :hotels, dependent: :destroy
  
  validates :country, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  
  def duration_days
    return nil unless start_date && end_date
    (end_date - start_date).to_i
  end
  
  private
  
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
