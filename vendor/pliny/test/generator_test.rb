require "test_helper"

describe Pliny::Generator do
  before do
    @gen = Pliny::Generator.new({}, StringIO.new)
  end

  describe "#class_name" do
    it "builds a class name" do
      @gen.args = ["model", "resource_history"]
      assert_equal "ResourceHistory", @gen.class_name
    end
  end

  describe "#table_name" do
    it "uses the plural form" do
      @gen.args = ["model", "resource_history"]
      assert_equal "resource_histories", @gen.table_name
    end
  end

  describe "#run!" do
    before do
      FileUtils.mkdir_p("/tmp/plinytest")
      Dir.chdir("/tmp/plinytest")
      Timecop.freeze(@t=Time.now)
    end

    after do
      FileUtils.rmdir("/tmp/plinytest")
      Timecop.return
    end

    describe "generating models" do
      before do
        @gen.args = ["model", "artist"]
        @gen.run!
      end

      it "creates a migration" do
        assert File.exists?("db/migrate/#{@t.to_i}_create_artists.rb")
      end

      it "creates the actual model" do
        assert File.exists?("lib/models/artist.rb")
      end

      it "creates a test" do
        assert File.exists?("test/models/artist_test.rb")
      end
    end
  end
end
