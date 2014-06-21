class AddCssSelectorToSource < ActiveRecord::Migration
  def change
    add_column :sources, :css_selector, :string
  end
end
