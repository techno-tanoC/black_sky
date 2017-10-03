module RSpecHelper
  def leads
    if block_given?
      subject
      expect(yield)
    else
      expect { subject }
    end
  end
end
