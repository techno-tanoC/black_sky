require 'spec_helper'

RSpec.describe BlackSky::Store do
  let(:store) { BlackSky::Store.new }

  before do
    store.add(:a, 1)
    store.add(:b, 2)
    store.add(:c, 3)
  end

  describe "#all" do
    subject { store.all }
    it "returns all stuff" do
      is_expected.to eq({a: 1, b: 2, c: 3})
    end
  end

  describe "#fetch" do
    subject { store.fetch(:b) }
    it "returns specified stuff" do
      is_expected.to eq(2)
    end
  end

  describe "#store" do
    subject { store.add(:d, 4) }
    it "deletes specified stuff" do
      leads.to change(store, :all).from({a: 1, b: 2, c: 3}).to({a: 1, b: 2, c: 3, d: 4})
    end
  end

  describe "#delete" do
    subject { store.delete(:b) }
    it "deletes specified stuff" do
      leads.to change(store, :all).from({a: 1, b: 2, c: 3}).to({a: 1, c: 3})
    end
  end

  describe "#bracket" do
    subject { store.fetch(:d) }

    context "when inside of block" do
      it "don't have the value" do
        store.bracket(:d, 4) do
        end

        is_expected.to be_nil
      end
    end

    context "when outside of block" do
      it "have the value" do
        store.bracket(:d, 4) do
          is_expected.to_not be_nil
        end
      end
    end
  end
end
