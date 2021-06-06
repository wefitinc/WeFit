class AddReasonColumnInServiceRequests < ActiveRecord::Migration[5.2]
  def change
  	add_column :service_requests, :reason, :string
  end
end
