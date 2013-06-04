require "code_master/version"

module CodeMaster
  require "code_master/railtie" if defined?(Rails)

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def behave_code_master(property = :code, values = [])
      define_method "master_code?" do |o|
        code = self.respond_to?(property) ? self.send(property) : nil
        return code.nil? ? false : code.to_s == o.to_s
      end
      define_method "master_codes" do
        return values
      end
      values.each do |o|
        define_method "#{o}?" do
          code = self.respond_to?(property) ? self.send(property) : nil
          return code.nil? ? false : code.to_s == o.to_s
        end
      end

      (class << self; self end).class_eval do
        define_method "master_codes" do
          return values
        end
      end
    end

    def import_code_master(args = {})
      args.each do |property, type|
        if type.method_defined?(:master_codes)
          type.new.master_codes.each do |code|
            define_method "#{code}?" do
              master = self.respond_to?(property) ? self.send(property) : nil
              if master.nil?
                return false
              elsif master.is_a? Enumerable
                master.each do |o|
                  return true if o.send("#{code}?")
                end
                return false
              else
                return master.send("#{code}?")
              end
            end
          end
        end
      end
    end
  end
end
