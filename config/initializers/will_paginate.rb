# Rails 8.1 does not trigger will_paginate's on_load hooks early enough,
# so load the Active Record and Action View integrations explicitly.
require "will_paginate/active_record"
require "will_paginate/view_helpers/action_view"
