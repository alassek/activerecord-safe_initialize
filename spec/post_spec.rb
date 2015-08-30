describe Post do
  before(:all) { Post.create(title: "Test Post", body: "This is a test.", uuid: SecureRandom.uuid) }
  after(:all)  { Post.first.destroy }

  context "with standard after_initialize" do
    let(:klass) do
      Class.new(Post).tap do |k|
        k.after_initialize { self.uuid ||= SecureRandom.uuid }
      end
    end

    it "works fine when all columns are selected" do
      expect{ klass.first }.to_not raise_error
    end

    it "raises ActiveModel::MissingAttributeError when uuid is not selected" do
      expect{ klass.select(:title).first }.to raise_error(ActiveModel::MissingAttributeError)
    end
  end

  context "with safe_initialize" do
    let(:klass) do
      Class.new(Post).tap do |k|
        k.safe_initialize :uuid, with: ->{ SecureRandom.uuid }
      end
    end

    it "does not raise an error when uuid is missing" do
      expect{ klass.select(:title).first }.to_not raise_error
    end
  end
end
