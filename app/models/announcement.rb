class Announcement < ApplicationRecord
  has_one_attached :image # Active Storage association

  validates :title, presence: true
  validates :image, presence: true

  def self.ransackable_associations(auth_object = nil)
    [ "image_attachment", "image_blob" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "image_url", "title", "updated_at" ]
  end
end
