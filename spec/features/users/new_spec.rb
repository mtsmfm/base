require 'rails_helper'

describe 'Creating user' do
  before { login_as create :admin, :scrooge }

  it 'creates a user' do
    visit new_user_path

    expect(page).to have_title 'Create User - Base'
    expect(page).to have_active_navigation_items 'Users', 'Create User'
    expect(page).to have_breadcrumbs 'Base', 'Users', 'Create'
    expect(page).to have_headline 'Create User'

    fill_in 'user_name',                  with: 'newname'
    fill_in 'user_email',                 with: 'somemail@example.com'
    fill_in 'user_about',                 with: 'Some info about me'
    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    expect(page).to have_css '#user_name[maxlength="100"]'

    attach_file 'user_avatar', dummy_file_path('other_image.jpg')

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create User'
      expect(page).to have_link 'List of Users'
    end

    click_button 'Create User'

    expect(page).to have_flash 'User was successfully created.'
  end

  # These specs make sure that the rather tricky image upload things are working as expected
  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'image.jpg'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      attach_file 'user_avatar', dummy_file_path('other_image.jpg')

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'other_image.jpg'
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit new_user_path

      # Upload a file
      attach_file 'user_avatar', dummy_file_path('image.jpg')

      # Trigger validation error
      click_button 'Create User'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Remove avatar
      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'

      click_button 'Create User'

      expect(page).to have_flash 'User was successfully created.'
      expect(User.last.avatar.to_s).to eq ''
    end
  end

  describe 'textarea fullscreen feature of "about" textarea', js: true do
    it 'applies the fullscreenizer' do
      visit new_user_path

      expect(page).to have_css '.textarea-fullscreenizer'
    end

    it 'shows the fullscreen toggler on focus' do
      visit new_user_path

      within '.user_about' do
        expect(page).not_to have_css '.textarea-fullscreenizer-focus'
        expect(page).not_to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'

        focus_element('#user_about')
        expect(page).to have_css '.textarea-fullscreenizer-focus'
        expect(page).to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'

        unfocus_element('#user_about')
        expect(page).not_to have_css '.textarea-fullscreenizer-focus'
        expect(page).not_to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'
      end
    end

    it 'shows the fullscreen toggler on hover' do
      visit new_user_path

      within '.user_about' do
        expect(page).not_to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'
        find('#user_about').hover
        expect(page).to have_css '.textarea-fullscreenizer-toggler', text: 'Toggle fullscreen (Esc)'
      end
    end

    it 'toggles fullscreen on pressing the fullscreen toggler' do
      visit new_user_path

      within '.user_about' do
        find('#user_about').hover
        expect(page).not_to have_css '.textarea-fullscreenizer-fullscreen'

        find('.textarea-fullscreenizer-toggler').trigger('click')
        expect(page).to have_css '.textarea-fullscreenizer-fullscreen'
        expect(focused_element_id).to eq 'user_about'

        find('.textarea-fullscreenizer-toggler').trigger('click')
        expect(page).not_to have_css '.textarea-fullscreenizer-fullscreen'
        expect(focused_element_id).to eq 'user_about'
      end
    end

    # Toggling using esc can't be tested (afaik), see http://stackoverflow.com/questions/35177110/testing-javascript-using-rspec-capybara-how-to-improve-my-spec-for-testing-a-t
  end
end
