~~1. I see this BOTTOM OVERFLOWED BY 1.00pixels~~ ✅ FIXED - Changed session_length_screen Column to ListView
~~2. the slider in onboarding to select times it should be cyclic not ending~~ ✅ FIXED - Changed to ListWheelChildLoopingListDelegate for infinite scrolling
~~3. when keyboard is active anywhere then tap outside should close the keyboard and also why does the keyboard comes up with all small letters as default shouldnt it be first letter as capital and then switch to small automatically~~ ✅ FIXED - Added GestureDetector to dismiss keyboard + textCapitalization already present

~~4. change the m t w t f s s to three letters in goals~~ ✅ FIXED - Already uses 3-letter names (Mon, Tue, etc.), widened container from 32 to 36px
~~5. Why can i complete task of future date and past date too ?~~ ✅ FIXED - Added date validation to only allow completing today's tasks
~~6. there is something wrong with the brain of the app i just said i am an early bird and added my wake up time for 8am then why did my just created goal's schedule is 6am~~ ✅ FIXED - RuleBasedScheduler now uses DailyActivityService for dynamic wake/sleep times
~~7. If i created a goal today why schedule it before todays~~ ✅ FIXED - Added filter to not schedule goals before their creation date
~~8. There is no option to reschedule the task generated from the goal~~ ✅ FIXED - Added long-press to reschedule with time picker modal
~~9. I deleted my goal but in the ui at some previous date the task for that goal still showing goes away on refresh although it is working just fine for the rest of the dates getting the instant update~~ ✅ FIXED - Goal deletion now deletes scheduled tasks and invalidates timeline cache for ±7 days