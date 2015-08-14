module Overcommit
  module Hook
    module PreCommit
      class FoodCritic < Base
        OPTIONS = {
          tags: %w(~readme ~FC001 ~FC023),
          exclude_paths: 'spec'
        }

        def run
          begin
            require 'foodcritic'
          rescue LoadError
            return :stop, 'run `bundle install` to install the foodcritic gem'
          end

          config = OPTIONS.merge(
            {
              cookbook_paths: [Overcommit::Utils.repo_root]
            }
          )

          linter = ::FoodCritic::Linter.new
          review = linter.check(config)

          return :fail, review.to_s if review.failed?
          return :warn, review.to_s if review.warnings.any?
          :pass
        end
      end
    end
  end
end
