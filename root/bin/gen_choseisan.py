#!/usr/bin/env python3

import datetime
import calendar


def get_schedule(year, month):
    schedule = []

    # Japanese weekdays
    japanese_weekdays = ["月", "火", "水", "木", "金", "土", "日"]

    # Get the number of days in the current month
    days_in_month = calendar.monthrange(year, month)[1]

    # Iterate through each day of the month
    for day in range(1, days_in_month + 1):
        date = datetime.date(year, month, day)
        weekday = date.weekday()
        day_name = japanese_weekdays[weekday]  # Get the Japanese weekday name

        if weekday < 5:  # Monday to Friday
            schedule.append(f"{month}/{day}({day_name}) 20:00〜")
        else:  # Saturday and Sunday
            schedule.append(f"{month}/{day}({day_name}) 10:00〜")
            schedule.append(f"{month}/{day}({day_name}) 14:00〜")
            schedule.append(f"{month}/{day}({day_name}) 20:00〜")

    return schedule


# Get the schedule and print it
year = 2024
month = 7
schedule = get_schedule(year, month)
for event in schedule:
    print(event)
