describe ActiveRecord::SafeInitialize do
  before(:all) { Post.create(title: "Test Post", body: "This is a test.", uuid: nil) }
  after(:all)  { Post.first.destroy }

  context "with: missing" do
    it "raises ArgumentError" do
      expect{ Post.safe_initialize(:uuid) }.to raise_error(ArgumentError)
    end
  end

  context "with: String" do
    it "uses the value as the default" do
      klass = Class.new(Post)
      klass.safe_initialize :uuid, with: 'foo'

      expect( klass.first.uuid ).to eq 'foo'
    end
  end

  context "with: Symbol" do
    it "sends the symbol to self to get value" do
      klass = Class.new(Post)
      klass.class_eval { def init_uuid; 'bar'; end }
      klass.safe_initialize :uuid, :with => :init_uuid

      expect( klass.first.uuid ).to eq 'bar'
    end
  end

  context "with: callable" do
    it "instance execs the callable to get the value" do
      klass = Class.new(Post)
      klass.class_eval { def init_uuid; 'baz'; end }
      klass.safe_initialize :uuid, with: ->{ self.init_uuid }

      expect( klass.first.uuid ).to eq 'baz'
    end
  end

  context "existing value" do
    let(:uuid) { SecureRandom.uuid }

    before(:each) { Post.first.update_attribute :uuid, uuid }

    it "does nothing" do
      klass = Class.new(Post)
      klass.safe_initialize :uuid, with: 'foo'

      expect( klass.first.uuid ).to eq uuid
    end
  end
end
