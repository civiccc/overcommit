module Overcommit::Hook::PreCommit
  # Look for the multiple ways that you can focus specs with RSpec and make sure
  # that none exist.
  class RspecFocusCheck < Base
    def run
      result = execute(%w{
                           grep
                           -nIHE
                           '^\s*((describe)|(context)|(feature)|(scenario)|(f?it))'
                           scout_spec.rb
                           |
                           grep
                           -E
                           '(:focused\s*=>)|(:focus\s*=>)|(focus:)|(focused:)|(:\d+:\s*fit\s)'
                         } +
                         applicable_files)

      unless result.stdout.empty?
        return :bad, "Focused RSpec spec found:\n#{result.stdout}"
      end

      :good
    end
  end
end
