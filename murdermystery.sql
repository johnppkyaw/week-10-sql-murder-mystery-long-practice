--Schemas
CREATE TABLE crime_scene_report (
  date integer,
  type text,
  description text,
  city text
  );

CREATE TABLE person (id integer PRIMARY KEY, name text, license_id integer, address_number integer, address_street_name text, ssn CHAR REFERENCES income (ssn), FOREIGN KEY (license_id) REFERENCES drivers_license (id))

CREATE TABLE interview (
person_id integer,
transcript text,
FOREIGN KEY (person_id) REFERENCES person(id) );

CREATE TABLE drivers_license (
  id integer PRIMARY KEY,
  age integer, height integer,
  eye_color text, hair_color text,
  gender text,
  plate_number text,
  car_make text,
  car_model text
  );

CREATE TABLE facebook_event_checkin (
  person_id integer,
  event_id integer,
  event_name text,
  date integer,
  FOREIGN KEY (person_id) REFERENCES person(id)
  );

CREATE TABLE get_fit_now_member ( id text PRIMARY KEY, person_id integer, name text, membership_start_date integer, membership_status text, FOREIGN KEY (person_id) REFERENCES person(id) )

CREATE TABLE get_fit_now_check_in ( membership_id text, check_in_date integer, check_in_time integer, check_out_time integer, FOREIGN KEY (membership_id) REFERENCES get_fit_now_member(id) )

CREATE TABLE solution ( user integer, value text )

CREATE TABLE income (ssn CHAR PRIMARY KEY, annual_income integer)

--The crime was a ​murder​ that occurred sometime on ​Jan.15, 2018​ and that it took place in ​SQL City​.
SELECT * FROM crime_scene_report WHERE date = 20180115 AND city = 'SQL City' AND type = 'murder';

--Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

--First witness (4919 Northwestern Dr)
SELECT transcript, person.address_number FROM interview
JOIN person ON(person.id = interview.person_id)
WHERE person.address_street_name = "Northwestern Dr" ORDER BY person.address_number DESC limit 1;
--I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".

--Second witness (Annabel Miller)
SELECT transcript, person.name FROM interview
JOIN person ON(person.id = interview.person_id)
WHERE person.name LIKE 'Annabel %' AND person.address_street_name = 'Franklin Ave';
--I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th. (2018)

--CONNECT ALL INFO
SELECT get_fit_now_member.name FROM get_fit_now_member
	JOIN get_fit_now_check_in ON(get_fit_now_check_in.membership_id = get_fit_now_member.id)
	JOIN person ON(person.id = get_fit_now_member.person_id)
	JOIN drivers_license ON(drivers_license.id = person.license_id)
	WHERE get_fit_now_check_in.check_in_date = 20180109 AND
		get_fit_now_member.membership_status = 'gold' AND
		get_fit_now_check_in.membership_id LIKE '%48Z%' AND
		drivers_license.plate_number LIKE '%H42W%';

--Jeremy Bowers
SELECT transcript FROM interview
	JOIN person ON(person.id = interview.person_id)
	WHERE person.name = 'Jeremy Bowers';
--I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.

SELECT name FROM person
JOIN drivers_license ON(person.license_id = drivers_license.id)
JOIN facebook_event_checkin ON(facebook_event_checkin.person_id = person.id)
WHERE gender = 'female' AND
	height BETWEEN 65 AND 67 AND
	hair_color = 'red' AND
	car_make = 'Tesla' AND
	car_model = 'Model S' AND
	facebook_event_checkin.event_name = 'SQL Symphony Concert' AND
	facebook_event_checkin.date BETWEEN 20171200 AND 20171231;

--Miranda Priestly
INSERT INTO solution VALUES (1, 'Miranda Priestly');
  SELECT value FROM solution;

--Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!
