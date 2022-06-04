require 'rails_helper'

describe '投稿機能' ,type: :system do
  let(:user_a) {FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com')}
  let(:user_b) {FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com')}
  let!(:post_image) {FactoryBot.build(:post_image,shop_name: 'testshop',user: user_a).save}

  before do
    visit new_user_session_path
    fill_in 'Email',with: login_user.email
    fill_in 'Password' ,with: login_user.password
    click_button 'Log in'
  end

  shared_examples_for 'ユーザーが作成したタスクが表示される' do
    it { expect(page).to have_content 'testshop'  }
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it 'ユーザーAが作成した投稿が表示される' do
        expect(page).to have_content 'testshop'# 作成済みの投稿が画面に表示されていることを確認
      end

      it 'マイページに作成した投稿が表示される' do
        show_link = find_all('a')[3]
        show_link.click
        expect(page).to have_content 'testshop'
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'ユーザーAが作成した投稿が表示される' do
        expect(page).to have_content 'testshop'# 作成済みの投稿が画面に表示されていることを確認
      end

      it 'ユーザーAが作成した投稿が表示されない' do
        show_link = find_all('a')[3]
        show_link.click
        expect(page).to have_no_content 'testshop'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーがログインしているとき' do
      let(:login_user) {user_a}

      before do
        show_link = find_all('a')[4]
        show_link.click
      end

      it_behaves_like 'ユーザーが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) {user_a}

    before do
      visit new_post_image_path
      fill_in 'post_image_shop_name',with: post_name
      fill_in 'post_image_caption' ,with: post_cap
      # post post_images_path,params: {post_image: { image: Rack::Test::UploadedFile.new(File.join(Rails.root,'/spec/fixture/test_image.jpg'),"image/jpg")}}
      attach_file 'post_image[image]', "#{Rails.root}/spec/fixture/test_image.jpg"
      click_button '投稿'
    end

    context '新規作成画面で名称を入力したとき' do
      let(:post_name) { '新規作成のテストを書く' }
      let(:post_cap) { '000' }

      it '正常に登録される' do
        expect(page).to have_content '新規作成のテストを書く'
      end
    end

    context '新規作成画面で名称を入力しなかった時' do
      let(:post_name) { '' }
      let(:post_cap) { '000' }

      it 'エラーになる' do
        within '.alert-danger li' do
          expect(page).to have_content 'Shop name can\'t be blank'
        end
      end
    end
  end

end