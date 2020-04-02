psql --d root -U root --command "create view active_listings as select * from listings where exists (select * from calendar where available = 't' and listings.id = calendar.listing_id and date between last_scraped and last_scraped + interval '1 year') or exists (select * from reviews where listings.id = reviews.listing_id and date between last_scraped - interval '1 year' and last_scraped)"
psql --d root -U root --command  "\COPY (select (select count(*) as all from listings), (select count(*) as active from active_listings)) TO '/out/active.csv' DELIMITER ',' CSV HEADER;"
python3 /host/create-diagram.py /out/active.csv /out/active.png