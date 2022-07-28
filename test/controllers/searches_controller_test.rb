require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get serarch" do
    get searches_serarch_url
    assert_response :success
  end
end
