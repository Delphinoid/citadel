require 'rails_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:avatar_file) { File.open('spec/support/avatar.png') }

  context 'User model' do
    let(:user) { build_stubbed(:user) }
    let(:uploader) { AvatarUploader.new(user, :avatar) }

    it 'has fallback' do
      url = ActionController::Base.helpers.asset_path 'fallback/user_avatar_default.png'
      expect(uploader.url).to eq(url)
    end

    it 'succesfully uploads' do
      uploader.store!(avatar_file)

      expect(uploader).to be_no_larger_than(200, 200)
      expect(uploader.icon).to be_no_larger_than(100, 100)
      expect(uploader.thumb).to be_no_larger_than(32, 32)
    end

    it 'handles duplicates' do
      user2 = build_stubbed(:user)
      uploader2 = AvatarUploader.new(user2, :avatar)

      uploader.store!(avatar_file)
      uploader2.store!(avatar_file)

      expect(uploader.url).to_not eq(uploader2.url)
    end

    it 'changes path for consecutive uploads' do
      uploader.store!(avatar_file)
      first_url = uploader.url

      uploader.store!(avatar_file)

      expect(uploader.url).to_not eq(first_url)
    end
  end
end
