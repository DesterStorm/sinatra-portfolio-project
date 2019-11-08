class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :position
      t.integer :company_id # because open positions belong to a specific companies
      t.timestamps null: false
    end
  end
end
