require 'database_cleaner'

module DatabaseHelper
  def teardown
    super
    DatabaseCleaner.clean
  end
end

