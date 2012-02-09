BEGIN TRANSACTION;
CREATE TABLE "links" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "fromnode" integer, "tonode" integer, "polyline" varchar(255), "fromlatitude" varchar(255), "fromlongitude" varchar(255), "tolatitude" varchar(255), "tolongitude" varchar(255), "gmaps" boolean, "created_at" datetime, "updated_at" datetime);
INSERT INTO links VALUES(1,0,3,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-09 00:33:07.595320','2012-02-09 00:33:07.595320');
INSERT INTO links VALUES(2,2,5,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-09 00:33:07.777331','2012-02-09 00:33:07.777331');
INSERT INTO links VALUES(3,3,4,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-09 00:33:07.866336','2012-02-09 00:33:07.866336');
INSERT INTO links VALUES(4,4,2,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-09 00:33:08.010344','2012-02-09 00:33:08.010344');
INSERT INTO links VALUES(5,5,0,NULL,NULL,NULL,NULL,NULL,NULL,'2012-02-09 00:33:08.088349','2012-02-09 00:33:08.088349');
CREATE TABLE "nodes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "latitude" float, "longitude" float, "gmaps" boolean, "name" varchar(255), "street" varchar(255), "number" varchar(255), "city" varchar(255), "country" varchar(255), "demand" float, "depot" boolean, "project_id" integer, "polyline" varchar(255), "tour_id" integer, "earliest" varchar(255), "latest" varchar(255), "user_id" integer, "created_at" datetime, "updated_at" datetime);
INSERT INTO nodes VALUES(1,52.3942,9.75592,'t','Meyer','Liebigstr. 33',NULL,'Hannover','Germany',NULL,'t',NULL,NULL,NULL,0,4000,2,'2012-02-08 23:14:19.719901','2012-02-09 00:31:48.779812');
INSERT INTO nodes VALUES(2,52.4611802,9.4842421,'t','Blau GmbH','Auf der Wakhorst 5',NULL,'Bordenau','Germany',22.0,'f',NULL,NULL,NULL,0,4000,2,'2012-02-08 23:15:26.007693','2012-02-09 00:32:26.926994');
INSERT INTO nodes VALUES(3,52.3966745,9.767725,'t','Meyer KG','podbielskistr. 123',NULL,'Hannover','Germany',12.0,'f',NULL,NULL,NULL,11,4000,2,'2012-02-08 23:16:00.290654','2012-02-09 00:32:35.696496');
INSERT INTO nodes VALUES(4,52.3791768,9.7238821,'t','Muster AG','Königsworther Platz 1',NULL,'Hannover','Germany',60.0,'f',NULL,NULL,NULL,0,4000,2,'2012-02-08 23:16:45.565243','2012-02-09 00:32:43.307931');
INSERT INTO nodes VALUES(5,52.454136,9.7602063,'t','Muster AG','Grenzheide 4',NULL,'Langenhagen','Germany',40.0,'f',NULL,NULL,NULL,0,4000,2,'2012-02-08 23:18:05.843835','2012-02-09 00:32:51.011372');
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "user_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
INSERT INTO schema_migrations VALUES(20111212083950);
INSERT INTO schema_migrations VALUES(20111212100825);
INSERT INTO schema_migrations VALUES(20111212115648);
INSERT INTO schema_migrations VALUES(20111214110830);
INSERT INTO schema_migrations VALUES(20120123201131);
INSERT INTO schema_migrations VALUES(20120123224714);
INSERT INTO schema_migrations VALUES(20120124005023);
INSERT INTO schema_migrations VALUES(20120203122359);
INSERT INTO schema_migrations VALUES(20120207161942);
CREATE TABLE sqlite_sequence(name,seq);
INSERT INTO sqlite_sequence VALUES('users',2);
INSERT INTO sqlite_sequence VALUES('vehicles',2);
INSERT INTO sqlite_sequence VALUES('nodes',5);
INSERT INTO sqlite_sequence VALUES('links',5);
CREATE TABLE "tours" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "servicetime" varchar(255), "maxduration" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "email" varchar(255), "distance_accuracy" boolean, "duration_accuracy" boolean, "tourduration" varchar(255), "created_at" datetime, "updated_at" datetime, "encrypted_password" varchar(255), "salt" varchar(255));
INSERT INTO users VALUES(1,'Peter Max','mario2@mall.de',NULL,NULL,NULL,'2012-02-08 22:04:20.060695','2012-02-08 22:04:20.060695','0e23de05c9321690c63e51dcf31244f25c8e9b12a88ae090b81431327738457e','83ac924c8e7aae43ad69b2e68b037a01d1568e8a0fd881a6d0bca8b5c41859ce');
INSERT INTO users VALUES(2,'mario','peter@peter.de','f','f',100000,'2012-02-08 22:25:18.076649','2012-02-09 00:31:18.317070','954adc98567fdd4589eb3e52450781fa1620593dd13cfcb70f6f3c7129ce9a2d','fb08a8b8007cb31f23f174495baed6b8fba3ea10c5fb6f5cbaf0eb23ff639426');
CREATE TABLE "vehicles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "VehicleName" varchar(255), "Type" varchar(255), "Capacity" float, "project_id" integer, "user_id" integer, "created_at" datetime, "updated_at" datetime);
INSERT INTO vehicles VALUES(1,'H-TB8213','Sprinter',123.0,NULL,2,'2012-02-08 23:13:41.088692','2012-02-08 23:13:41.088692');
INSERT INTO vehicles VALUES(2,'H-TB8214','Sprinter',150.0,NULL,2,'2012-02-08 23:13:58.178669','2012-02-08 23:13:58.178669');
CREATE INDEX "index_nodes_on_project_id" ON "nodes" ("project_id");
CREATE INDEX "index_nodes_on_tour_id" ON "nodes" ("tour_id");
CREATE INDEX "index_nodes_on_user_id" ON "nodes" ("user_id");
CREATE INDEX "index_projects_on_user_id" ON "projects" ("user_id");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE INDEX "index_vehicles_on_project_id" ON "vehicles" ("project_id");
CREATE INDEX "index_vehicles_on_user_id" ON "vehicles" ("user_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
COMMIT;