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

  describe '#copy' do
    context 'with a extension' do
      it 'copies the file' do
        expected = <<~EOS
          cp a ./b.c
          chown 1000:1000 ./b.c
          chmod 600 ./b.c
        EOS

        expect {
          renamer.copy("a", "b", "c")
        }.to output(expected).to_stderr_from_any_process
      end
    end

    context 'without a extension' do
      it 'copies the file' do
        expected = <<~EOS
          cp a ./b
          chown 1000:1000 ./b
          chmod 600 ./b
        EOS

        expect {
          renamer.copy("a", "b", "")
        }.to output(expected).to_stderr_from_any_process

        expect {
          renamer.copy("a", "b", nil)
        }.to output(expected).to_stderr_from_any_process
      end
    end

    context 'with duplicated file' do
      it 'copies the file' do
        expected = <<~EOS
          cp Gemfile.lock ./Gemfile(1)
          chown 1000:1000 ./Gemfile(1)
          chmod 600 ./Gemfile(1)
        EOS

        expect {
          renamer.copy("Gemfile.lock", "Gemfile", "")
        }.to output(expected).to_stderr_from_any_process
      end
    end
  end
end
