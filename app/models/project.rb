# frozen_string_literal: true
class Project < ApplicationRecord
  has_and_belongs_to_many :jewels

  validates :name, :url, presence: true
  validates :stars_count, presence: { unless: proc { |p| p.new_record? } }
end
