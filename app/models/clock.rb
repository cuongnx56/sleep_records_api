class Clock < ApplicationRecord
  belongs_to :user

  enum action: { go_bed: 1, wake_up: 2 }

  scope :by_created_at_desc, -> { order(created_at: :desc) }
end
