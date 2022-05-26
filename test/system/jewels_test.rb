require "application_system_test_case"

class JewelsTest < ApplicationSystemTestCase
  setup do
    @jewel = jewels(:one)
  end

  test "visiting the index" do
    visit jewels_url
    assert_selector "h1", text: "Jewels"
  end

  test "should create jewel" do
    visit jewels_url
    click_on "New jewel"

    fill_in "Name", with: @jewel.name
    click_on "Create Jewel"

    assert_text "Jewel was successfully created"
    click_on "Back"
  end

  test "should update Jewel" do
    visit jewel_url(@jewel)
    click_on "Edit this jewel", match: :first

    fill_in "Name", with: @jewel.name
    click_on "Update Jewel"

    assert_text "Jewel was successfully updated"
    click_on "Back"
  end

  test "should destroy Jewel" do
    visit jewel_url(@jewel)
    click_on "Destroy this jewel", match: :first

    assert_text "Jewel was successfully destroyed"
  end
end
