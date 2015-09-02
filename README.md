# ActiveRecord::SafeInitialize
[![Build Status](https://travis-ci.org/lyconic/activerecord-safe_initialize.svg)](https://travis-ci.org/lyconic/activerecord-safe_initialize)

Safely initialize an ActiveRecord attribute with respect to missing columns.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-safe_initialize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-safe_initialize

## Usage

If you want to select subsets of SQL tables, you have to use `after_initialize` with care:

```ruby
class Post < ActiveRecord::Base
  after_initialize { self.category ||= 'Default' }
end

Post.select([:title, :body, :published_at]).first # => ActiveModel::MissingAttributeError
```

To do this safely you must write:

```ruby
class Post < ActiveRecord::Base
  after_initialize { self.category ||= 'Default' if has_attribute?(:category) }
end
```

With `safe_initialize` you can write:

```ruby
class Post < ActiveRecord::Base
  safe_initialize :category, with: 'Default'
end
```

If `with` is a Symbol, `safe_initialize` will send it to `self` to get the value:

```ruby
class Post < ActiveRecord::Base
  safe_initialize :uuid, with: :generate_uuid

private

  def generate_uuid
    SecureRandom.uuid
  end
end
```

If `with` is callable, it will `instance_exec` it to get the value:

```ruby
class Post < ActiveRecord::Base
  safe_initialize :uuid, with: ->{ SecureRandom.uuid }
end
```

You can set a default for multiple attributes at once:

```ruby
class Employee < ActiveRecord::Base
  safe_initialize :pay_rate, :holiday_rate, with: 0.0
end
```

## Contributing

1. Fork it ( https://github.com/lyconic/activerecord-safe_initialize/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
