require 'rails_helper'
require 'sidekiq/testing'

describe Oven do
  before(:all) do
    Sidekiq::Testing.fake!
  end

  subject { FactoryGirl.create(:oven) }

  before do
    subject.cookie = FactoryGirl.create(:cookie)
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:cookie) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:user) }
  end

  describe ".cook" do
    it "should enqueue a cooking job" do
      expect {
        subject.cook
      }.to change(CookingWorker.jobs, :size).by(1)
    end
  end
end
