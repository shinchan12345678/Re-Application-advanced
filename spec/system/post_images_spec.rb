require 'rails_helper'

describe '投稿機能' ,type: :system do
  describe '一覧表示機能' do
    before do
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')
      post_image=FactoryBot.build(:post_image,shop_name: 'testshop',user: user_a)
      post_image.save
    end

    context 'ユーザーAがログインしているとき' do
      before do
        visit new_user_session_path# ユーザーAでログインする
        fill_in 'Email',with: 'a@example.com'
        fill_in 'Password' ,with: 'password'
        click_button 'Log in'
      end

      it 'ユーザーAが作成した投稿が表示される' do
        expect(page).to have_content 'testshop'# 作成済みの投稿が画面に表示されていることを確認
      end

      it 'マイページに作成した投稿が表示される' do
        show_link = find_all('a')[4]
        show_link.click
        expect(page).to have_content 'testshop'
      end
    end

    context 'ユーザーBがログインしているとき' do
      before do
        user_b = FactoryBot.create(:user,name: 'ユーザーB', email: 'b@example.com')
        visit new_user_session_path
        fill_in 'Email',with: 'b@example.com'
        fill_in 'Email',with: 'password'
        click_button 'Log in'
      end

      it 'ユーザーAが作成した投稿が表示されない' do
        show_link = find_all('a')[4]
        show_link.click
        expect(page).to have_no_content 'testshop'
      end
    end
  end
end