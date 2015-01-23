module ApplicationHelper
      def forgot_password_url
      	return Settings.base_url + "/#/users/password/edit"
      end 
      todays_date = Date.today #Date.today.to_s
      week_start_date = todays_date.at_beginning_of_week.strftime
      week_end_date = todays_date.at_end_of_week.strftime
      next_week_start_date = (todays_date.at_beginning_of_week + 7).strftime
      next_week_end_date = (todays_date.at_beginning_of_week + 11).strftime
      CURRENTWEEKNO = todays_date.strftime("%W").to_i + 1
      NEXTWEEKNO = todays_date.strftime("%W").to_i + 2
      PRESENTYEAR = Date.today.strftime("%Y").to_i
end
