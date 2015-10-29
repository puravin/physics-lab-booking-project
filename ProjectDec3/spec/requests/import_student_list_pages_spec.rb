require 'spec_helper'

describe "ImportStudentListPages" do
  describe "browse button" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { sign_in user }

      describe "clicking on browse... button" do
        before { visit 'csv_import/student_list' }

    end
  end
end
