class ClockSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :action, :go_bed_at, :wake_up_at, :created_at

end
