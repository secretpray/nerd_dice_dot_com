require "test_helper"

# For configuration and customization of browser driven tests
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # needed in order to test email delivery in System Tests
  include ActionMailer::TestHelper

  DRIVER = if ENV["BROWSER_TEST_DRIVER"]
    ENV["BROWSER_TEST_DRIVER"].to_sym
  else
    :headless_chrome
  end

  driven_by :selenium, using: DRIVER, screen_size: [1400, 1400]

  # helper method for welcome page assertions
  def welcome_page_not_logged_in_assertions!
    assert_text "Nerd Dice"
    assert_text "Sign up"
    assert_text "Log in"
    assert_no_text "Visit the members' area"
    assert_no_text "Manage your account"
    assert_no_text "Log out"
  end

  def welcome_page_logged_in_assertions!
    assert_text "Nerd Dice"
    assert_no_text "Sign up"
    assert_no_text "Log in"
    assert_text "Visit the members' area"
    assert_text "Manage your account"
    assert_text "Log out"
  end

  def login_with_user!(user)
    login_with_credentials!(user.email, FIXTURE_USER_PASSWORDS[user.email])
  end

  def login_with_credentials!(email, password)
    visit new_user_session_url
    login_page_assertions!
    fill_in "Email", with: email
    fill_in "Password", with: password
    check "Remember me"
    click_on "Log in"
  end

  def login_page_assertions!
    assert_text "Log in"
    assert_text "Remember me"
    assert_text "Sign up"
    assert_text "Forgot your password?"
    assert_text "Didn't receive confirmation instructions?"
    assert_text "Didn't receive unlock instructions?"
  end

  def registrations_edit_assertions!
    assert_text "Edit User"
    assert_text "Email"
    assert_selector "input#user_email[value='#{@user.email}']"
    assert_text "Password (leave blank if you don't want to change it)"
    assert_text "8 characters minimum"
    assert_text "Password confirmation"
    assert_text "Current password"
    assert_text "(we need your current password to confirm your changes)"
    assert_text "Cancel my account"
    assert_text "Unhappy?"
  end

  # Get a validation message from a page element
  # @param current_selector the unique selector of the element to find the message for
  #
  # Will return the validationMessage of the element (empty string if none)
  def get_input_validation_message(current_selector)
    page.find(current_selector).native.attribute("validationMessage")
  end
end
