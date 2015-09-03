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

    it "accepts a block argument in place of :with" do
      klass = Class.new(Post)
      klass.safe_initialize :uuid do
        SecureRandom.uuid
      end

      expect{ klass.new }.to_not raise_error
      expect( klass.new.uuid ).to_not be nil
    end

    it "warns if both :with and block are present" do
      klass = Class.new(Post)

      expect(klass).to receive(:warn)

      klass.safe_initialize :uuid, with: 'Foo' do
        'Bar'
      end
    end

    it "uses :with instead of block if both are present" do
      klass = Class.new(Post)
      klass.safe_initialize :uuid, with: 'Foo' do
        'Bar'
      end

      expect( klass.new.uuid ).to eq 'Foo'
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

  context "multiple attributes" do
    it "creates a default for each one" do
      klass = Class.new(Post)

      expect{ klass.safe_initialize :title, :body, :uuid, with: 'foo' }.to_not raise_error

      inst = klass.new
      expect( inst.title ).to eq 'foo'
      expect( inst.body ).to eq 'foo'
      expect( inst.uuid ).to eq 'foo'
    end
  end

  context "with conditional arguments" do
    it "does not run if: false" do
      klass = Class.new(Post)
      klass.class_eval do
        safe_initialize :uuid, with: ->{ SecureRandom.uuid }, :if => :new_record?
        def new_record?; false; end
      end

      inst = klass.new

      expect( inst.uuid ).to be nil
    end

    it "does not run unless: true" do
      klass = Class.new(Post)
      klass.class_eval do
        safe_initialize :uuid, with: ->{ SecureRandom.uuid }, :unless => :foo?
        def foo?; true; end
      end

      inst = klass.new

      expect( inst.uuid ).to be nil
    end
  end
end
