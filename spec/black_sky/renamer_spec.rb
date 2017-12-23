RSpec.describe BlackSky::Renamer do
  let(:renamer) { BlackSky::Renamer.new(".") }

  describe "#fresh_name" do
    context "when the file exists" do
      subject { renamer.send(:fresh_name, "black_sky", "mp4") }
      it "returns the duplicated name" do
        is_expected.to eq("./black_sky.mp4")
      end
    end

    context "when the file doesn't exists" do
      subject { renamer.send(:fresh_name, "black_sky", "gemspec") }
      it "returns the duplicated name" do
        is_expected.to eq("./black_sky(1).gemspec")
      end
    end
  end
end
