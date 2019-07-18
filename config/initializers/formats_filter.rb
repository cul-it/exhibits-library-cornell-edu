# frozen_string_literal: true

puts 'Protecting against security vulnerability for actionview < 5.1.2.6' # rubocop:disable Rails/Output

ActionDispatch::Request.prepend(Module.new do
  def formats
    super().select do |format|
      format.symbol || format.ref == "*/*"
    end
  end
end)
