require 'spec_helper'

RSpec.describe BlackSky::Progress do
  let(:pg) { BlackSky::Progress.new("hanamaru") }
  subject { pg.to_h }

  describe "#set_total" do
    before { pg.set_total(1000) }

    it "sets total" do
      is_expected.to eq({name: "hanamaru", total: 1000, size: 0})
    end
  end

  describe "#increment" do
    before do
      pg.increment(100)
      pg.increment(100)
    end

    it "sets total" do
      is_expected.to eq({name: "hanamaru", total: 0, size: 200})
    end
  end

  describe "#to_h" do
    it "convert the progress to the hash" do
      is_expected.to eq({name: "hanamaru", total: 0, size: 0})
    end
  end
end
