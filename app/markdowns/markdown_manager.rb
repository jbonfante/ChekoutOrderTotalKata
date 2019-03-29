require './app/base/base_manager'
require './app/markdowns/markdown'

class MarkdownManager < BaseManager
  def initialize
    super
    @managed_klass = Markdown
  end
end
