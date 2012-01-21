require 'factory_girl'

FactoryGirl.define do
  factory :notice do
    message "RuntimeError: run Forest, run!"
    association :error
  end

  factory :error do
    exception "RuntimeError"
    backtrace "blah blah: on line 13"
  end
end
