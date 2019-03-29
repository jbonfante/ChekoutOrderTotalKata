require './app/base/base_manager'
require './app/specials/special'

class SpecialsManager < BaseManager
  def initialize
    super
    @managed_klass = Special
  end
end
