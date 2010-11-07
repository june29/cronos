# -*- coding: utf-8 -*-

require "rubygems"
require "rspec"

require "cronos"

def time(year, month, day, hour, minute)
  Time.local(year, month, day, hour, minute)
end

describe Cronos do
  before(:all) do
    @base = Time.local(2010, 10, 10, 10, 10)
  end

  describe "の基本フォーマットについて" do
    it "次の1件の実行タイミングを取得できること" do
      cronos = Cronos.new("* * * * *")
      cronos.schedule(:from => @base).should == time(2010, 10, 10, 10, 11)
    end

    it "次の1件の実行タイミングを取得できること" do
      cronos = Cronos.new("30 * * * *")
      cronos.schedule(:from => @base).should == time(2010, 10, 10, 10, 30)
    end

    it "次の1件の実行タイミングを取得できること" do
      cronos = Cronos.new("0 15 * * *")
      cronos.schedule(:from => @base).should == time(2010, 10, 10, 15, 0)
    end

    it "次の1件の実行タイミングを取得できること" do
      cronos = Cronos.new("0 15 30 * *")
      cronos.schedule(:from => @base).should == time(2010, 10, 30, 15, 0)
    end

    it "次の2件の実行タイミングを取得できること" do
      cronos = Cronos.new("* * * * *")
      cronos.schedules(:from => @base, :size => 2).should == [time(2010, 10, 10, 10, 11),
                                                              time(2010, 10, 10, 10, 12)]
    end

    it "指定時刻までのすべての実行タイミングを取得できること" do
      cronos = Cronos.new("5 * * * *")
      cronos.schedules(:from => @base, :to => time(2010, 10, 10, 16, 0)).should == [time(2010, 10, 10, 11, 5),
                                                                                    time(2010, 10, 10, 12, 5),
                                                                                    time(2010, 10, 10, 13, 5),
                                                                                    time(2010, 10, 10, 14, 5),
                                                                                    time(2010, 10, 10, 15, 5)]
    end
  end

  describe "のカンマ区切りのリストについて" do
    it "次の1件の実行タイミングを取得できること" do
      cronos = Cronos.new("5,15,25 * * * *")
      cronos.schedule(:from => @base).should == time(2010, 10, 10, 10, 15)
    end

    it "次の2件の実行タイミングを取得できること" do
      cronos = Cronos.new("5,15,25 * * * *")
      cronos.schedules(:from => @base, :size => 2).should == [time(2010, 10, 10, 10, 15),
                                                              time(2010, 10, 10, 10, 25)]
    end
  end

  describe "のハイフンで指定する範囲について" do
    it "次の1件の実行タイミングを取得できること" do
      cronos = Cronos.new("15-25 * * * *")
      cronos.schedule(:from => @base).should == time(2010, 10, 10, 10, 15)
    end

    it "次の1件の実行タイミングを取得できること" do
      cronos = Cronos.new("5-15 * * * *")
      cronos.schedule(:from => @base).should == time(2010, 10, 10, 10, 11)
    end

    it "次の3件の実行タイミングを取得できること" do
      cronos = Cronos.new("10-12 * * * *")
      cronos.schedules(:from => @base, :size => 3).should == [time(2010, 10, 10, 10, 11),
                                                              time(2010, 10, 10, 10, 12),
                                                              time(2010, 10, 10, 11, 10)]
    end
  end

  describe "の曜日指定について" do
    it "0は日曜日と解釈されること" do
      cronos = Cronos.new("0 0 * * 0")
      cronos.schedule(:from => @base).should == time(2010, 10, 17, 0, 0)
    end

    it "6は土曜日と解釈されること" do
      cronos = Cronos.new("0 0 * * 6")
      cronos.schedule(:from => @base).should == time(2010, 10, 16, 0, 0)
    end

    it "7は日曜日と解釈されること" do
      cronos = Cronos.new("0 0 * * 7")
      cronos.schedule(:from => @base).should == time(2010, 10, 17, 0, 0)
    end
  end

  describe "に複数のスケジュール指定したとき" do
    it "いずれかの指定を満たす実行タイミングを取得できること" do
      cronos = Cronos.new("45 23 * * *", "15 0 * * *")
      cronos.schedule(:from => time(2010, 10, 12, 23, 44)).should == time(2010, 10, 12, 23, 45)
      cronos.schedule(:from => time(2010, 10, 12, 23, 45)).should == time(2010, 10, 13,  0, 15)
    end
  end
end
