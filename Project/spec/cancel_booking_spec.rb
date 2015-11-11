require 'spec_helper'

# For my user story. More like usability testing.
describe 'make_booking/view_experiment.html.erb', :type => :view do
	before(:all) do
		assign(:dates, Array.new)
		assign(:bookings, Array.new)
		assign(:experiment, Experiment.new(:name => "physics 1", :exp_num => 15, :num_sessions => 2, :weight => 2))
		assign(:student, Student.create(:sid => 123456789, :first_name => "Frodo", :last_name => "Baggins", :cp => 4, :comments => "The ring is mine.", :email => "frodo@baggins.com"))
	end


	it 'should not be able to cancel' do
		assign(:earliest_date, Date.today)
		assign(:min_day_cancel_booking, 4)
		render
		rendered.should match(/Unable to cancel booking/)
	end

	it 'should be able to cancel' do
		assign(:earliest_date, Date.today + 7)
		assign(:min_day_cancel_booking, 4)
		render
		rendered.should_not match(/Unable to cancel booking/)
	end
end
