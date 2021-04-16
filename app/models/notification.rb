class Notification < ApplicationRecord
	enum action: [:like, :comment, :attention, :follow, :activity_attend, :activity_cancellation, :group_invite, 
		:group_acceptance, :group_join_request, :group_privacy_change, :message, :service_purchasal, :service_fulfilled, 
		:service_review, :service_payment, :service_delay, :service_refund, :service_rejection, :service_acceptance, 
		:service_funds_transfer, :professional_account_acceptance, :professional_account_rejection]
end
