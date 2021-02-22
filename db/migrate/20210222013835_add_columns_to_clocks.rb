class AddColumnsToClocks < ActiveRecord::Migration[6.0]
  def change
    add_column :clocks, :go_bed_at, :datetime
    add_column :clocks, :wake_up_at, :datetime
  end
end
