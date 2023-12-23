require 'rails_helper'

feature "An authenticated user can vote for a question/answer he likes. ", %q{
  In order to highlight a question/answer I like, 
  as an authentecated user 
  I want to be able to vote for a question/answer I like
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

  describe "Unauthenticated user"  do
    background do
      visit question_path(question)
    end

    scenario 'can not add like/dislike to a question' do
      within '.question_votes' do
        expect(page).to_not have_link "UP"
        expect(page).to_not have_link "DOWN"
      end
    end  
    
    scenario 'Unauthenticated user can not add like/dislike to an answer' do
      within '.answer_votes' do
        expect(page).to_not have_link "Up"
        expect(page).to_not have_link "Down"
      end
    end
  end

  describe "Authenticated user"  do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'can add like to a question he likes', js: true do
      within '.question_votes' do
        rating = (page.find(:css, "#change_rating").value).to_i
        click_on 'UP'   
        expect(page).to have_content("#{rating+1}")
      end
    end

    scenario 'can add like to an answer he likes', js: true do
      within '.answer_votes' do
        rating = (page.find(:css, "#change_answer_rating").value).to_i
        click_on 'UP'
        expect(page).to have_content("#{rating+1}")
      end
    end

    scenario "can add dislike to an answer he doesn't like", js: true do
      within '.answer_votes' do
        rating = (page.find(:css, "#change_answer_rating").value).to_i
        click_on 'DOWN'
        expect(page).to have_content("#{rating-1}")
      end 
    end

    scenario "can add dislike to a question he doesn't like", js: true do
      within '.question_votes' do
        rating = (page.find(:css, "#change_rating").value).to_i
        click_on 'DOWN'
        expect(page).to have_content("#{rating-1}")
      end
    end

    scenario "can add like for question just once", js: true do
      within '.question_votes' do
        rating = (page.find(:css, "#change_rating").value).to_i
        click_on 'UP'
        click_on 'UP'
        expect(page).to have_content("#{rating+1}")
      end
      expect(page).to have_content("You couldn't vote twice!")
    end

    scenario "can add dislike for question just once", js: true do
      within '.question_votes' do
        rating = (page.find(:css, "#change_rating").value).to_i
        click_on 'DOWN'
        click_link 'DOWN'
        expect(page).to have_content("#{rating-1}")
      end
      expect(page).to have_content("You couldn't vote twice!")
    end

    scenario "can add like for answer just once", js: true do
      within '.answer_votes' do
        rating = (page.find(:css, "#change_answer_rating").value).to_i
        click_on 'UP'
        click_on 'UP'
        expect(page).to have_content("#{rating+1}")
      end
      expect(page).to have_content("You couldn't vote twice!")
    end

    scenario "can add dislike for question just once", js: true do
      within '.answer_votes' do
        rating = (page.find(:css, "#change_answer_rating").value).to_i
        click_on 'DOWN'
        click_link 'DOWN'
        expect(page).to have_content("#{rating-1}")
      end
      expect(page).to have_content("You couldn't vote twice!")
    end
  end  

  describe "Author "  do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'cannot vote for his question', js: true do
      within '.question_votes' do
        rating = (page.find(:css, "#change_rating").value).to_i  
        click_on 'UP'
        expect(page).to have_content("#{rating}")
      end
      expect(page).to have_content("You couldn't vote for your question")
    end

    scenario 'cannot vote for his answer', js: true do
     within '.answer_votes' do
        rating = (page.find(:css, "#change_answer_rating").value).to_i 
        click_on 'UP'
        expect(page).to have_content("#{rating}")
      end
      expect(page).to have_content("You couldn't vote for your answer")
    end
  end
end
