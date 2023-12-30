These are test routines
To run a test, use the ".include" directive to include a "test.s" file in the "kernel.s" file. Then, add a "b _teststart" instruction right after the "_sysmain" label in "kernel.s".
Only one test file may be included at a time.

