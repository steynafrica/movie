

create table query1 as select g.name, count(*) from genres g, hasagenre h where g.genreid=h.genreid group by g.name;



drop table if exists temp1; 
create temporary table temp1 as select h.genreid, r.rating from ratings r,hasagenre h where r.movieid = h.movieid order by h.genreid;
create table query2 as select g.name, avg(t.rating) from genres g, temp1 t where g.genreid = t.genreid group by g.name;




create table query3 as select m.title, (count(r.rating)) as CountOfRatings from movies m, ratings r where m.movieid = r.movieid  group by m.title having count(r.rating)>=10;



drop table if exists temp2; 
create temporary table temp2 as select h.movieid from hasagenre h, genres g where h.genreid = g.genreid and g.name = 'Comedy';
create table query4 as select m.movieid, m.title from movies m, temp2 t where m.movieid = t.movieid;



create table query5 as select m.title, avg(rating) from ratings r, movies m where r.movieid = m.movieid group by m.movieid;



drop table if exists temp3;
create temporary table temp3 as select h.movieid from hasagenre h, genres g where h.genreid = g.genreid and g.name = 'Comedy';
create table query6 as select avg(r.rating) from ratings r, temp3 t1 where r.movieid = t1.movieid;



drop table if exists moviestemp2;
create temporary table moviestemp2 as select h.movieid from hasagenre h, genres g where g.name = 'Comedy' and h.genreid = g.genreid;
drop table if exists moviestemp3;
create temporary table moviestemp3 as select h.movieid from hasagenre h, genres g, moviestemp2 t2 where g.name = 'Romance' and h.genreid = g.genreid and h.movieid = t2.movieid;
create table query7 as select avg(r.rating) from ratings r, moviestemp3 t3 where r.movieid = t3.movieid;



drop table if exists moviestemp4;
create temporary table moviestemp4 as select distinct h.movieid from hasagenre h, genres g where g.name = 'Romance' and h.genreid = g.genreid and h.movieid not in (select h.movieid from hasagenre h, genres g where g.name = 'Comedy' and h.genreid = g.genreid);
create table query8 as select avg(r.rating) from ratings r, moviestemp4 t4 where r.movieid = t4.movieid;




create table query9 as select movieid, rating from ratings where userid = :v1;



drop table if exists table1;
create temporary table table1 as select movieid, avg(rating) as rating1 from ratings group by movieid order by movieid;

drop table if exists table2;
create temporary table table2 as select movieid, avg(rating) as rating2 from ratings group by movieid order by movieid;

drop table if exists table3;
create temporary table table3 as select t1.movieid as m1, t2.movieid as m2, 1 - ((abs(rating1 - rating2))/5) as similarity from table1 t1, table2 t2 where t1.movieid!= t2.movieid;

drop table if exists table4;
create temporary table table4 as select r.movieid, r.rating from ratings r where userid = :v1;

drop table if exists table5;
create temporary table table5 as select r.movieid,r.rating from ratings r where r.movieid not in (select movieid from table4);

drop table if exists table6;
create temporary table table6 as select t4.movieid as movieid1, t5.movieid as movieid2, t3.similarity as sim, (t3.similarity*t4.rating) as userrating from table3 t3, table4 t4, table5 t5
where t4.movieid = t3.m1 and t5.movieid = t3.m2;

drop table if exists table7;
create temporary table table7 as select t6.movieid2 as id, sum(t6.userrating)/sum(sim) as totalrating from table6 t6 group by t6.movieid2;

create table recommendation as select m.title from movies m, table7 t7 where m.movieid = t7.id and t7.totalrating>3.9 ;

