require 'business_hours'

describe BusinessHours do

  before(:each) do
    @hours = BusinessHours.new("9:00 AM", "3:00 PM")
  end

  describe "#update" do
    it "changes the opening and closing time for a given day" do
      @hours.update :fri, "10:00 AM", "5:00 PM"
      @hours[:fri][:opens].should == "10:00 AM"
      @hours[:fri][:closes].should == "5:00 PM"
    end

    it "accepts specific days as a string" do
      @hours.update "Dec 24, 2010", "8:00 AM", "1:00 PM"
      @hours["Dec 24, 2010"][:opens].should == "8:00 AM"
      @hours["Dec 24, 2010"][:closes].should == "1:00 PM"
    end
  end

  describe "#closed" do
    it "specifies which days the shop is not open" do
      @hours.closed :sun, :wed, "Dec 25, 2010"
      @hours[:sun][:closed].should == true
      @hours[:wed][:closed].should == true
      @hours["Dec 25, 2010"][:closed].should == true
      @hours["Dec 26, 2010"][:closed].should == true
      @hours["Dec 27, 2010"][:closed].should == false
    end
  end

  describe "#calculate_deadline" do
    before do
      @hours.update :fri, "10:00 AM", "5:00 PM"
      @hours.update "Dec 24, 2010", "8:00 AM", "1:00 PM"
      @hours.closed :sun, :wed, "Dec 25, 2010"
    end

    context "when delivery fits in same day" do
      it "returns a time later that day" do
        @hours.calculate_deadline(2*60*60, "Jun 7, 2010 9:10 AM").should  == Time.parse("Mon Jun 07 11:10:00 2010")
      end
    end

    context "when delivery doesn't fit same day" do
      it "returns a time the next open day" do
        @hours.calculate_deadline(15*60, "Jun 8, 2010 2:48 PM").should    == Time.parse("Thu Jun 10 09:03:00 2010")
        @hours.calculate_deadline(7*60*60, "Dec 24, 2010 6:45 AM").should == Time.parse("Mon Dec 27 11:00:00 2010")
      end
    end
  end
end
