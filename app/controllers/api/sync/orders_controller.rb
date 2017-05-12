class Api::Sync::OrdersController < Api::BaseController
	skip_before_filter :authenticate_user

end