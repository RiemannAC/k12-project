require 'test_helper'

class TtopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ttopic = ttopics(:one)
  end

  test "should get index" do
    get ttopics_url
    assert_response :success
  end

  test "should get new" do
    get new_ttopic_url
    assert_response :success
  end

  test "should create ttopic" do
    assert_difference('Ttopic.count') do
      post ttopics_url, params: { ttopic: { end_time: @ttopic.end_time, name: @ttopic.name, start_time: @ttopic.start_time } }
    end

    assert_redirected_to ttopic_url(Ttopic.last)
  end

  test "should show ttopic" do
    get ttopic_url(@ttopic)
    assert_response :success
  end

  test "should get edit" do
    get edit_ttopic_url(@ttopic)
    assert_response :success
  end

  test "should update ttopic" do
    patch ttopic_url(@ttopic), params: { ttopic: { end_time: @ttopic.end_time, name: @ttopic.name, start_time: @ttopic.start_time } }
    assert_redirected_to ttopic_url(@ttopic)
  end

  test "should destroy ttopic" do
    assert_difference('Ttopic.count', -1) do
      delete ttopic_url(@ttopic)
    end

    assert_redirected_to ttopics_url
  end
end
