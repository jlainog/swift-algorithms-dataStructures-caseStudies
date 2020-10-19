#  Search As You Type

The idea behind this it to create a reusable solution using **combine** for consulting a Search API as you type a query.

### Main points:
* Don't start searching until a minimun characters (3 will be fine) is reached.
* Avoid duplicates if posible.
* Delay or debounce the request so calls are not done for each character but instead after a given time. (300 to 500 millisecons will be fine).
* Cancel in flight request when a new one is trigered.

For the UI only show a text result for the seach.

[01-SeachAsYouTypeView](../CaseStudies/01-SeachAsYouTypeView.swift)
