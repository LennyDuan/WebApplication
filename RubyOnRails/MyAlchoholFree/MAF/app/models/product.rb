class Product < ActiveRecord::Base
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :origin, :grape, :company, :size, :content,
    presence:true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :content, numericality: {greater_than_or_equal_to: 0.00}
  validates :size, numericality: {greater_than_or_equal_to: 100}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG, PNG'
  }
  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end
  def self.like(query)
    if query.nil?
      []
    else 
      where('title LIKE :query ' +
            'OR description LIKE :query ' +
            'OR origin LIKE :query ' +
            'OR grape LIKE :query',
            query: "%#{query}%")
    end end
end