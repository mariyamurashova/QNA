require 'rails_helper'

feature 'User can edit his question', %q{
  In order to coorect mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  
  given(:author) { create (:user) }
  given(:user) { create (:user) }
  given!(:question) { create (:question), author: author }
  given!(:link) { create(:link, linkable: question) }
  given(:gist_url) {'https://gist.github.com/mariyamurashova'}

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "user tries to edit other user's question", js: true do
    sign_in user
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'EditQuestion'
    end   
  end

  describe 'Author' do

    background do
      sign_in author
      visit question_path(question) 
      click_on 'EditQuestion'
      fill_in "Title", with: 'edited question title'
      fill_in "Body", with: 'edited question body'
    end
      
      scenario 'edits his question', js: true do
        within '.question' do
          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.title
          expect(page).to have_content 'edited question title'
          expect(page).to have_content 'edited question body'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his question with errors', js: true do
        within '.question' do
          fill_in "Title", with: ' '
          fill_in "Body", with: ' '
          click_on 'Save'
          expect(page).to have_selector 'textarea'
        end

        within '.errors' do
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'edits his question with attached files', js: true do
        attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'can delete links from his question', js: true do
        click_on 'Delete link'
        page.driver.browser.switch_to.alert.accept
        
        within ".question" do
          expect(page).to_not have_link 'MyGistFactory'
        end
      end

      scenario 'can add links to his question', js: true do

        within '.question' do
          click_on 'Add Link' 
          fill_in 'Link name', with:  'My gist'
          fill_in 'Url', with: gist_url
          click_on 'Save'
      
          expect(page).to have_link 'MyGistFactory'
          expect(page).to have_link 'My gist', href: gist_url
        end
      end
  
  
      describe 'with attached files' do

        background do
          question.files.attach(io: File.open(Rails.root.join('spec', 'fixtures', '1.txt')), filename: '1.txt', content_type: 'text/txt')
          visit question_path(question) 
          click_on 'EditQuestion'
        end

      scenario 'can add files to his question', js: true do
        within '.question' do
          attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
          expect(page).to have_link '1.txt'
        end
      end

      scenario 'can delete attached files', js: true do
        within '.question' do
          click_on 'Delete file'
          page.driver.browser.switch_to.alert.accept

          expect(page).to_not have_link '1.txt'
        end
      end
    end 
  end
end
