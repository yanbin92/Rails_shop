CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "products" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "description" text, "image_url" varchar, "price" decimal(8,2), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "carts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "line_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "product_id" integer, "cart_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "quantity" integer DEFAULT 1, "price" decimal, "order_id" integer);
CREATE INDEX "index_line_items_on_product_id" ON "line_items" ("product_id");
CREATE INDEX "index_line_items_on_cart_id" ON "line_items" ("cart_id");
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "address" text, "email" varchar, "pay_type" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_line_items_on_order_id" ON "line_items" ("order_id");
CREATE TABLE "payment_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "password_digest" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "is_access" bool);
CREATE TABLE "legacy_books" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "pictures" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "comment" varchar, "name" varchar, "content_type" varchar, "data" blob(1048576));
INSERT INTO schema_migrations (version) VALUES ('20161012000610'), ('20161026024907'), ('20161026031915'), ('20161026084345'), ('20161026085849'), ('20161027014917'), ('20161028073456'), ('20161029144846'), ('20161029152849'), ('20161030121914'), ('20161103070657'), ('20161108071729'), ('20161212063431');


