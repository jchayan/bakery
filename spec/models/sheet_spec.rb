require 'rails_helper'

RSpec.describe Sheet, type: :model do
  subject { FactoryGirl.create(:sheet) }

  describe "associations" do
    it { is_expected.to belong_to(:oven).without_validating_presence }
    it { is_expected.to have_many(:cookies) }
  end

  describe ".ready?" do
    it 'is true if the sheet is empty' do
      expect(subject.ready?).to eq(true)
    end

    it 'is true if all cookies are ready' do
      subject.cookies << FactoryGirl.create(:cookie, ready: true)
      subject.cookies << FactoryGirl.create(:cookie, ready: true)

      expect(subject.ready?).to eq(true)
    end

    it 'is false if a cookie is not ready' do
      subject.cookies << FactoryGirl.create(:cookie, ready: false)
      subject.cookies << FactoryGirl.create(:cookie, ready: true)

      expect(subject.ready?).to eq(false)
    end

    it 'is false if all cookies are not ready' do
      subject.cookies << FactoryGirl.create(:cookie, ready: false)
      subject.cookies << FactoryGirl.create(:cookie, ready: false)

      expect(subject.ready?).to eq(false)
    end
  end
end
