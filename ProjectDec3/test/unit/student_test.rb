require File.expand_path("../../test_helper", __FILE__)

class StudentTest < ActiveSupport::TestCase
	test "won't create without sid given" do
		student = Student.new
		assert !student.save, "created new student without id"
	end
	
	test "should not create without a unique SID" do
		student = Student.create(:sid => 123456789, :first_name => "Frodo", :last_name => "Baggins", :cp => 4, :comments => "The ring is mine.", :email => "frodo@baggins.com")
		student_dup = Student.create(:sid => 123456789, :first_name => "Frodo", :last_name => "Baggins", :cp => 4, :comments => "The ring is mine.", :email => "frodo1@baggins.com")
		assert !student_dup.save, "created duplicate student"
	end
	
	test "should not create without a unique email" do
		student = Student.create(:sid => 123456789, :first_name => "Frodo", :last_name => "Baggins", :cp => 4, :comments => "The ring is mine.", :email => "frodo@baggins.com")
		student_dup = Student.create(:sid => 133456789, :first_name => "Frodo", :last_name => "Baggins", :cp => 4, :comments => "The ring is mine.", :email => "frodo@baggins.com")
		assert !student_dup.save, "created duplicate student"
	end
	
	test "should not create with an SID under 9 numbers" do
		student = Student.create(:sid => 12345678, :first_name => "Frodo", :last_name => "Baggins", :cp => 4, :comments => "The ring is mine.", :email => "frodo@baggins.com")
		assert !student.save, "created student with invalid SID"
	end
	
	test "should create with valid parameters" do
		student = Student.create(:sid => 123456789, :first_name => "Frodo", :last_name => "Baggins", :cp => 4, :comments => "The ring is mine.", :email => "frodo@baggins.com")
		assert student.save, "failed to create valid student"
	end
	
	test "should not create with invalid amount of credit points" do
		student = Student.create(:sid => 123456789, :first_name => "Frodo", :last_name => "Baggins", :cp => -2, :comments => "The ring is mine.", :email => "frodo@baggins.com")
		assert !student.save, "created student with -2 credit points"
	end
end