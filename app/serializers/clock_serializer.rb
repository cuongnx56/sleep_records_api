class ClockSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :action, :created_at

end
