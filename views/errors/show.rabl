object @error
attributes :id,
           :exception,
           :backtrace,
           :parameters,
           :session,
           :environment,
           :fingerprint,
           :file,
           :mode,
           :created_at,
           :updated_at,
           :resolved

code(:most_recent_notice_at) { |err| err.notices.last.created_at }
code(:notices_count) { |err| err.notices.count }
