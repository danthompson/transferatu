require "spec_helper"

module Transferatu
  describe Mediators::Schedules::Creator do
    describe ".call" do
      let(:group)      { create(:group) }
      let(:name)       { "Arthur" }
      let(:valid_tz)   { "America/New_York" }
      let(:bogus_tz)   { "America/Lodi" }
      let(:valid_hour) { 20 }
      let(:bogus_hour) { 26 }
      let(:valid_days) { %w(Monday Wednesday Friday) }
      let(:bogus_days) { %w(Caturday) }
      let(:valid_url)  { 'https://example.com/scheduled-transfers/123' }
      let(:bogus_url)  { 'ftp://example.com/scheduled-transfers/123' }

      it "creates a new schedule" do
        creator = Mediators::Schedules::Creator.new(group: group,
                                                    name: name,
                                                    callback_url: valid_url,
                                                    hour: valid_hour,
                                                    days: valid_days,
                                                    timezone: valid_tz,
                                                    retain_weeks: 3,
                                                    retain_months: 6)
        t = creator.call
        expect(t).to_not be_nil
        expect(t).to be_instance_of(Transferatu::Schedule)
      end

      it "defaults retention from the database if passed in as nil" do
        creator = Mediators::Schedules::Creator.new(group: group,
                                                    name: name,
                                                    callback_url: valid_url,
                                                    hour: valid_hour,
                                                    days: valid_days,
                                                    timezone: valid_tz,
                                                    retain_weeks: nil,
                                                    retain_months: nil)
        t = creator.call
        expect(t).to_not be_nil
        expect(t).to be_instance_of(Transferatu::Schedule)
        expect(t.retain_weeks).to eq(5)
        expect(t.retain_months).to eq(0)
      end

      it "fails with a bogus timezone" do
        expect {
          Mediators::Schedules::Creator.new(group: group,
                                            name: name,
                                            callback_url: valid_url,
                                            hour: valid_hour,
                                            days: valid_days,
                                            timezone: bogus_tz,
                                            retain_weeks: 3,
                                            retain_months: 6).call
        }.to raise_error
      end

      it "fails with a bogus hour" do
        expect {
          Mediators::Schedules::Creator.new(group: group,
                                            name: name,
                                            callback_url: valid_url,
                                            hour: bogus_hour,
                                            days: valid_days,
                                            timezone: valid_tz,
                                            retain_weeks: 3,
                                            retain_months: 6).call
        }.to raise_error
      end

      it "fails with a bogus set of days" do
        expect {
          Mediators::Schedules::Creator.new(group: group,
                                            name: name,
                                            callback_url: valid_url,
                                            hour: valid_hour,
                                            days: bogus_days,
                                            timezone: valid_tz,
                                            retain_weeks: 3,
                                            retain_months: 6).call
        }.to raise_error
      end

      it "fails with a bogus callback_url" do
        expect {
          Mediators::Schedules::Creator.new(group: group,
                                            name: name,
                                            callback_url: bogus_url,
                                            hour: valid_hour,
                                            days: valid_days,
                                            timezone: valid_tz,
                                            retain_weeks: 3,
                                            retain_months: 6).call
        }.to raise_error
      end
    end
  end
end
