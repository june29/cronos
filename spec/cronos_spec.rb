require "rubygems"
require "spec"

require "cronos"

describe Cronos do
  it "returns next" do
    cronos = Cronos.new("* * * * *")
    cronos.next(Time.local(2010, 10, 10, 10, 10)).should == Time.local(2010, 10, 10, 10, 11)
  end

  it "returns next" do
    cronos = Cronos.new("30 * * * *")
    cronos.next(Time.local(2010, 10, 10, 10, 10)).should == Time.local(2010, 10, 10, 10, 30)
  end

  it "returns next" do
    cronos = Cronos.new("0 15 * * *")
    cronos.next(Time.local(2010, 10, 10, 10, 10)).should == Time.local(2010, 10, 10, 15, 0)
  end
end
