require "spec_helper"
require "code_master"

class Master1
  include CodeMaster

  behave_code_master :code, [:admin, :user]

  def code()
    return "admin"
  end
end

class Master2
  include CodeMaster

  behave_code_master :code, [:banana, :apple]

  def code()
    return nil
  end
end

class Master3
  include CodeMaster

  behave_code_master :code, [:note, :pen]

  def code2()
    return nil
  end
end

class Model1
  include CodeMaster

  import_code_master :master1 => Master1, :master2 => Master2

  def master1()
    return Master1.new
  end
end

class Model2
  include CodeMaster

  import_code_master :master1 => Master1

  def master3()
    return Master3.new
  end
end

class Model3
  include CodeMaster

  import_code_master :master1 => Model1

  def master1()
    return Master1.new
  end
end

describe CodeMaster do
  describe ".behave_code_master" do
    describe "#master_code?" do
      subject(:model) { Master1.new }
      it { expect(model.master_code?("admin")).to be_true }
      it { expect(model.master_code?("user")).to be_false }
      it { expect(model.master_code?("unknown")).to be_false }
      it { expect(model.master_codes).to eq [:admin, :user] }

      context "when #code is nil" do
        subject(:model) { Master2.new }
        it { expect(model.master_code?("banana")).to be_false }
        it { expect(model.master_code?("apple")).to be_false }
        it { expect(model.master_code?("unknown")).to be_false }
      end
    end

    describe "generated #xxx?" do
      subject(:model) { Master1.new }
      it { expect(model.admin?).to be_true }
      it { expect(model.user?).to be_false }

      context "when #code is nil" do
        subject(:model) { Master2.new }
        it { expect(model.banana?).to be_false }
        it { expect(model.apple?).to be_false }
      end
    end

    context "when specified property isn't defined" do
      subject(:model) { Master3.new }
      it { expect(model.master_code?("note")).to be_false }
      it { expect(model.master_code?("pen")).to be_false }
      it { expect(model.note?).to be_false }
      it { expect(model.pen?).to be_false }
    end
  end

  describe ".import_code_master" do
    subject(:model) { Model1.new }
    it { expect(model.admin?).to be_true }
    it { expect(model.user?).to be_false }
    it { expect(model.banana?).to be_false }
    it { expect(model.apple?).to be_false }

    context "when specified property isn't defined" do
      subject(:model) { Model2.new }
      it { expect(model.admin?).to be_false }
      it { expect(model.user?).to be_false }
    end

    context "when specified property isn't code master" do
      subject(:model) { Model3.new }
      it { expect(model.respond_to?(:admin?)).to be_false }
      it { expect(model.respond_to?(:user?)).to be_false }
    end
  end
end
