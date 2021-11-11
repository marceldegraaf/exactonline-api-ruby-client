module Elmas
	class SalesItemPrice
	  include Elmas::Resource

	  def base_path
	    "logistics/SalesItemPrices"
	  end

	  def mandatory_attributes; end

	  def other_attributes
	    %i[account account_name created creator creator_full_name currency default_item_unit default_item_unit_description division end_date item
	       item_code item_description modified modifier modifier_full_name number_of_items_per_unit price quantity start_date unit unit_description]
	  end
	end
end
