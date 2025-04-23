class Tax < ApplicationRecord
  # Define searchable attributes for Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "id", "province", "gst", "pst", "hst", "created_at", "updated_at" ]
  end
end
