require "code_master"
require "rails"

module CodeMaster
  class Railtie < Rails::Railtie
    initializer "code_master.initialize" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :include, CodeMaster
      end
    end
  end
end
