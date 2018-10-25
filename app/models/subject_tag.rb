class SubjectTag < ApplicationRecord
  default_scope { order(created_at: :asc) }
  # topics_show 排序和 materials_index, plans_index 排序一致
  has_many :plans, dependent: :destroy
  has_many :materials, dependent: :destroy
end
