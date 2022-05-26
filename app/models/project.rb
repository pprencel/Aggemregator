class Project < ApplicationRecord

  has_and_belongs_to_many :jewels

  validates_presence_of :name, :stars_count, :url
end
