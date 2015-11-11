require File.expand_path("../../test_helper", __FILE__)

class ExperimentTest < ActiveSupport::TestCase
	test "won't create without name given" do
		experiment = Experiment.new
		assert !experiment.save, "saved experiment without critical information"
	end
	
	test "won't create if exp_num is not a number" do
		experiment = Experiment.new(:name => "physics 1", :exp_num => "aaa")
		assert !experiment.save, "created experiment with invalid experiment number"
	end
	
	test "should create with valid name and number" do
		experiment = Experiment.new(:name => "physics 1", :exp_num => 15, :num_sessions => 2, :weight => 2)
		assert experiment.save, "failed to create a valid experiment"
	end
end