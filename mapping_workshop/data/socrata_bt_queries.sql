#  ROUTES!

#  guadalupe southbound
("guadalupe_27th$guadalupe_26th$guadalupe_24th$guadalupe_21st$mlk_guadalupe$guadalupe_15th")

#  guadalupe northbound
("guadalupe_15th$mlk_guadalupe$guadalupe_21st$guadalupe_24th$guadalupe_26th$guadalupe_27th")

#  congress northbound
("congress_slaughter$congress_wm_cannon$congress_stassney$congress_benwhite$congress_oltorf$congress_elizabeth$riverside_congress$congress_cesar_chavez$congress_5th$congress_6th$congress_11th")

# congress southound
("congress_11th$congress_6th$congress_5th$congress_cesar_chavez$riverside_congress$congress_elizabeth$congress_oltorf$congress_benwhite$congress_stassney$congress_wm_cannon$congress_slaughter")

#  lamar southbound
("lamar_parmer$lamar_braker$lamar_rundberg$lamar_payton_gin$lamar_morrow$lamar_airport$lamar_koenig$lamar_51st$lamar_45th$lamar_38th$lamar_29th$lamar_24th$lamar_mlk$lamar_12th$lamar_6th$lamar_5th$lamar_riverside$lamar_barton_springs$lamar_lamar_square$lamar_oltorf$Lamar_Blue_Bonnet$Lamar_and_Manchca_Barton_skyway$lamar_panther$us290_wm_cannon$us290_tx71$tx71_silvermine")


#  lamar northbound
("tx71_silvermine$us290_tx71$us290_wm_cannon$lamar_panther$Lamar_and_Manchca_Barton_skyway$Lamar_Blue_Bonnet$lamar_oltorf$lamar_lamar_square$lamar_barton_springs$lamar_riverside$lamar_5th$lamar_6th$lamar_12th$lamar_mlk$lamar_24th$lamar_29th$lamar_38th$lamar_45th$lamar_51st$lamar_koenig$lamar_airport$lamar_morrow$lamar_payton_gin$lamar_rundberg$lamar_braker$lamar_parmer")


# South 1st Southbound
("lavaca_6th$lavaca_5th$cesar_chavez_lavaca$south_1st_barton_spring$south_1st_oltorf$south_1st_benwhite$south_1st_st_elmo$south_1st_stassney$south_1st_wm_cannon$south_1st_slaughter")


# South 1st Northbound
("south_1st_slaughter$south_1st_wm_cannon$south_1st_stassney$south_1st_st_elmo$south_1st_benwhite$south_1st_oltorf$south_1st_barton_spring$cesar_chavez_lavaca$lavaca_5th$lavaca_6th")

#  Individual Traffic Match Files (ITMF)

# 1. Compute average travel time for segments along a given route within a time range and day(s) of week
https://data.austintexas.gov/resource/922j-6afw.json?
$query=SELECT origin_reader_identifier, destination_reader_identifier, start_time, day_of_week, speed_miles_per_hour WHERE match_validity='valid' AND origin_reader_identifier || "$" || destination_reader_identifier in ("congress_slaughter$congress_wm_cannon", "congress_stassney$congress_wm_cannon", "congress_benwhite$congress_stassney", "congress_benwhite$congress_oltorf", "congress_elizabeth$congress_oltorf", "congress_elizabeth$riverside_congress", "congress_cesar_chavez$riverside_congress", "congress_5th$congress_cesar_chavez", "congress_5th$congress_6th", "congress_11th$congress_6th")
|> SELECT origin_reader_identifier, destination_reader_identifier, start_time, day_of_week, speed_miles_per_hour, CASE(origin_reader_identifier < destination_reader_identifier, origin_reader_identifier || '$' || destination_reader_identifier, destination_reader_identifier < origin_reader_identifier, destination_reader_identifier || '$' || origin_reader_identifier) AS segment_name 
|> SELECT start_time, day_of_week, speed_miles_per_hour, segment_name WHERE start_time LIKE('%25T16:%25')  OR start_time LIKE('%25T17:%25') OR start_time LIKE('%25T18:%25') 
|> SELECT start_time, day_of_week, speed_miles_per_hour, segment_name where UPPER(day_of_week) NOT IN('SATURDAY', 'SUNDAY')
|> SELECT segment_name, avg(speed_miles_per_hour), count(*) GROUP BY segment_name


