require 'rails_helper'

describe Cookie do
  subject { FactoryGirl.create(:cookie) }

  describe "associations" do
    it { is_expected.to belong_to(:storage) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:storage) }
  end

  describe ".cook!" do
    it "should set ready field to true" do
      subject.cook!
      expect(subject.ready).to eq(true)
    end
  end
end
