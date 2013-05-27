module UsersHelper
	def show_for_admins_only(object)
		if current_user.role == "admin"
			object
		end
	end

	def admin? 
		current_user.role == "admin"
	end	
end