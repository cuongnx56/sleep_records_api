class User < ApplicationRecord
  has_secure_password

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :clocks

  def following?(other_user_id)
    relationships.find_by(followed_id: other_user_id)
  end

  def follow!(other_user_id)
    relationships.create!(followed_id: other_user_id)
  end

  def unfollow!(other_user_id)
    relationships.find_by(followed_id: other_user_id)&.destroy
  end
end
