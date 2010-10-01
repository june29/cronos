require "rubygems"
require "spec"

require "cronos"

describe Cronos do
  describe "の基本フォーマットについて" do
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

    it "returns next" do
      cronos = Cronos.new("0 15 30 * *")
      cronos.next(Time.local(2010, 10, 10, 10, 10)).should == Time.local(2010, 10, 30, 15, 0)
    end
  end

  describe "のカンマ区切りのリストについて" do
    it "returns next" do
      cronos = Cronos.new("5,15,25 * * * *")
      cronos.next(Time.local(2010, 10, 10, 10, 10)).should == Time.local(2010, 10, 10, 10, 15)
    end
  end

  describe "のハイフンで指定する範囲について" do
    it "returns next" do
      cronos = Cronos.new("15-25 * * * *")
      cronos.next(Time.local(2010, 10, 10, 10, 10)).should == Time.local(2010, 10, 10, 10, 15)
    end

    it "returns next" do
      cronos = Cronos.new("15-25 * * * *")
      cronos.next(Time.local(2010, 10, 10, 10, 20)).should == Time.local(2010, 10, 10, 10, 21)
    end
  end
end
