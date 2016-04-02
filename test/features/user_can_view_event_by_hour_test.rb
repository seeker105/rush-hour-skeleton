require_relative '../test_helper'

class UserCanViewEventByHour < FeatureTest
  include TestHelpers

  def test_client_can_see_event_by_hour
    Client.create(identifier: "jumpstartlab",
                  root_url: "http://jumpstartlab.com")
    path = '/sources/jumpstartlab/event/hourly'
    visit path

    assert_equal path, current_path

    within("h2") do
      assert page.has_content?("Midnight: ")
      assert page.has_content?("0100-0200: ")
      assert page.has_content?("0200-0300: ")
      assert page.has_content?("0700-0800: ")
      assert page.has_content?("0800-0900:  ")
      assert page.has_content?("0900-1000:  ")
  end

end

