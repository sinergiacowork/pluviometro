require 'shoden'
require 'shoden/contrib'

class Rain < Shoden::Model
  include Shoden::Timestamps
  include Shoden::DataTypes

  attribute :mm, Type::Float
end
