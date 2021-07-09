create table users(userid int, name text, PRIMARY KEY(userid)); 
create table movies(movieid integer, title text, PRIMARY KEY(movieid)); 
create table taginfo(tagid int, content text, PRIMARY KEY(tagid));
create table genres(genreid integer, name text, PRIMARY KEY(genreid));
create table ratings(userid int, movieid int, rating numeric check (rating between 0 and 5), timestamp bigint, PRIMARY KEY(userid,movieid), FOREIGN KEY(userid) REFERENCES users(userid), FOREIGN KEY(movieid) REFERENCES movies(movieid) ON DELETE CASCADE);
create table tags(userid int, movieid int, tagid int, timestamp bigint,PRIMARY KEY(userid,movieid,tagid), FOREIGN KEY(userid) REFERENCES users(userid), FOREIGN KEY(movieid) REFERENCES movies(movieid) ON DELETE CASCADE, FOREIGN KEY(tagid) REFERENCES taginfo(tagid));
create table hasagenre(movieid int, genreid int, FOREIGN KEY(movieid) REFERENCES movies(movieid) ON DELETE CASCADE, FOREIGN KEY(genreid) REFERENCES genres(genreid));
