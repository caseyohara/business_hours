# The Challenge
Chunky Bacon Begone is a dry-cleaning company known for its speedy service. It guarantees to dry-clean anything within two business hours or less. The problem is, when the customer drops off the clothes, he needs to know what time they are guaranteed to be done.

It is your job to write a Ruby script which will determine the guaranteed time given a business hour schedule. You must create a class called BusinessHours which allows one to define the opening and closing time for each day. It should provide the following interface:

    hours = BusinessHours.new("9:00 AM", "3:00 PM")
    hours.update :fri, "10:00 AM", "5:00 PM"
    hours.update "Dec 24, 2010", "8:00 AM", "1:00 PM"
    hours.closed :sun, :wed, "Dec 25, 2010"

The update method should change the opening and closing time for a given day. The closed method should specify which days the shop is not open. Notice days can either be a symbol for week days or a string for specific dates. Any given day can only have one opening time and one closing time — there are no off-hours in the middle of the day.

A method called calculate_deadline should determine the resulting business time given a time interval (in seconds) along with a starting time (as a string). The returned object should be an instance of Time. Here are some examples:

    hours.calculate_deadline(2*60*60, "Jun 7, 2010 9:10 AM") # => Mon Jun 07 11:10:00 2010
    hours.calculate_deadline(15*60, "Jun 8, 2010 2:48 PM") # => Thu Jun 10 09:03:00 2010
    hours.calculate_deadline(7*60*60, "Dec 24, 2010 6:45 AM") # => Mon Dec 27 11:00:00 2010

In the first example the time interval is 2 hours (7,200 seconds). Since the 2 hours fall within business hours the day does not change and the interval is simply added to the starting time.

In the second line an interval of 15 minutes (900 seconds) is used. The starting time is 12 minutes before closing time which leaves 3 minutes remaining to be added to the next business day. The next day is Wednesday and therefore closed, so the resulting time is 3 minutes after opening on the following day.

The last example is 7 hours (25200 seconds) which starts before opening on Dec 24th. There are only 5 business hours on Dec 24th which leaves 2 hours remaining for the next business day. The next two days are closed (Dec 25th and Sunday) therefore the deadline is not until 2 hours after opening on Dec 27th.