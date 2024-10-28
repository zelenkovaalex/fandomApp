require "application_system_test_case"

class FandomsTest < ApplicationSystemTestCase
  setup do
    @fandom = fandoms(:one)
  end

  test "visiting the index" do
    visit fandoms_url
    assert_selector "h1", text: "Fandoms"
  end

  test "should create fandom" do
    visit fandoms_url
    click_on "New fandom"

    fill_in "Description", with: @fandom.description
    fill_in "Name", with: @fandom.name
    click_on "Create Fandom"

    assert_text "Fandom was successfully created"
    click_on "Back"
  end

  test "should update Fandom" do
    visit fandom_url(@fandom)
    click_on "Edit this fandom", match: :first

    fill_in "Description", with: @fandom.description
    fill_in "Name", with: @fandom.name
    click_on "Update Fandom"

    assert_text "Fandom was successfully updated"
    click_on "Back"
  end

  test "should destroy Fandom" do
    visit fandom_url(@fandom)
    click_on "Destroy this fandom", match: :first

    assert_text "Fandom was successfully destroyed"
  end
end
