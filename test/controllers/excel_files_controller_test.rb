require 'test_helper'

class ExcelFilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get excel_files_index_url
    assert_response :success
  end

  test "should get new" do
    get excel_files_new_url
    assert_response :success
  end

  test "should get create" do
    get excel_files_create_url
    assert_response :success
  end

  test "should get update" do
    get excel_files_update_url
    assert_response :success
  end

  test "should get destroy" do
    get excel_files_destroy_url
    assert_response :success
  end

  test "should get show" do
    get excel_files_show_url
    assert_response :success
  end

  test "should get edit" do
    get excel_files_edit_url
    assert_response :success
  end

end
