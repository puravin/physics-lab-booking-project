require 'test_helper'

class UploadReportsControllerTest < ActionController::TestCase
  setup do
    @upload_report = upload_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:upload_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create upload_report" do
    assert_difference('UploadReport.count') do
      post :create, upload_report: @upload_report.attributes
    end

    assert_redirected_to upload_report_path(assigns(:upload_report))
  end

  test "should show upload_report" do
    get :show, id: @upload_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @upload_report
    assert_response :success
  end

  test "should update upload_report" do
    put :update, id: @upload_report, upload_report: @upload_report.attributes
    assert_redirected_to upload_report_path(assigns(:upload_report))
  end

  test "should destroy upload_report" do
    assert_difference('UploadReport.count', -1) do
      delete :destroy, id: @upload_report
    end

    assert_redirected_to upload_reports_path
  end
end
