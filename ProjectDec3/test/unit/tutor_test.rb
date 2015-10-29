require File.expand_path("../../test_helper", __FILE__)

class TutorTest < ActiveSupport::TestCase
	test "should not save without username provided" do
		tutor = Tutor.new
		assert !tutor.save, "saved without username"
	end
	
	test "should not run without a unique username" do
		tutor = Tutor.create(:username => "testtutor", :first_name => "foo", :last_name => "bar", :email => "baz@baz.com")
		user = User.create(:username => "testtutor", :password => "asd", :role => "tutor", :details_id => "testtutor")
		tutor_dup = Tutor.create(:username => "testtutor", :first_name => "foo", :last_name => "bar", :email => "baz@baz.com")
		user_dup = User.create(:username => "testtutor", :password => "asd", :role => "tutor", :details_id => "testtutor")
		assert !user_dup.save
	end
	
	test "should not accept a password under 6 chars" do
		tutor = Tutor.create(:username => "testtutor", :first_name => "foo", :last_name => "bar", :email => "baz@baz.com")
		user = User.create(:username => "testtutor", :password => "asd", :role => "tutor", :details_id => "testtutor")
		assert !user.save
	end
	
	test "should not accept a password over 20 chars" do
		tutor = Tutor.create(:username => "testtutor", :first_name => "foo", :last_name => "bar", :email => "baz@baz.com")
		user = User.create(:username => "testtutor", :password => "veryveryveryveryveryvyerlongpassword1", :role => "tutor", :details_id => "testtutor")
		assert !user.save
	end
	
	test "should accept a password between 6 and 20 chars" do
		tutor = Tutor.create(:username => "testtutor", :first_name => "foo", :last_name => "bar", :email => "baz@baz.com")
		user = User.create(:username => "testtutor", :password => "password1", :role => "tutor", :details_id => "testtutor")
		assert tutor.save
	end
end