#extention of Date.gd from vanskodje-godotengine / godot-plugin-calendar-button 

extends Node

class_name Date

var day : int setget set_day
var month : int setget set_month
var year : int setget set_year
var hour : int setget set_hour
var minute : int setget set_minute
var seconds : int setget set_seconds

func _init(day : int = OS.get_datetime()["day"], 
		month : int = OS.get_datetime()["month"], 
		year : int = OS.get_datetime()["year"],
		hour : int = OS.get_datetime()["hour"],
		minute : int = OS.get_datetime()["minute"],
		seconds : int = OS.get_datetime()["second"]):
	self.day = day
	self.month = month
	self.year = year
	self.hour = hour
	self.minute = minute
	self.seconds = seconds

# Supported Date Formats:
# DD : Two digit day of month
# MM : Two digit month
# YY : Two digit year
# YYYY : Four digit year
func date(date_format = "DD-MM-YY") -> String:
	if("DD".is_subsequence_of(date_format)):
		date_format = date_format.replace("DD", str(day()).pad_zeros(2))
	if("MM".is_subsequence_of(date_format)):
		date_format = date_format.replace("MM", str(month()).pad_zeros(2))
	if("YYYY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YYYY", str(year()))
	elif("YY".is_subsequence_of(date_format)):
		date_format = date_format.replace("YY", str(year()).substr(2,3))
	return date_format

func day() -> int:
	return day

func month() -> int:
	return month

func year() -> int:
	return year

func hour() -> int:
	return hour	
	
func minute() -> int:
	return minute
	
func seconds() -> int:
	return seconds			
	
func set_day(var _day : int):
	day = _day

func set_month(var _month : int):
	month = _month

func set_year(var _year : int):
	year = _year
	
func set_hour(var _hour : int):
	hour = _hour	

func set_minute(var _minute : int):
	minute = _minute
		
func set_seconds(var _seconds : int):
	seconds = _seconds

func change_to_prev_month():
	var selected_month = month()
	selected_month -= 1
	if(selected_month < 1):
		set_month(12)
		set_year(year() - 1)
	else:
		set_month(selected_month)

func change_to_next_month():
	var selected_month = month()
	selected_month += 1
	if(selected_month > 12):
		set_month(1)
		set_year(year() + 1)
	else:
		set_month(selected_month)

func change_to_prev_year():
	set_year(year() - 1)

func change_to_next_year():
	set_year(year() + 1)
