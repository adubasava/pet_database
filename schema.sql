-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Create tables
-- Represents family pets
CREATE TABLE "pets" (
    "id" INTEGER,
    "type" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "date_of_birth" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

-- Represents performed regular treatments like vaccination, deworming etc.
CREATE TABLE "treatments" (
    "id" INTEGER,
    "pet_id" INTEGER,
    "procedure" TEXT NOT NULL,
    "drug" TEXT NOT NULL,
    "date_of_procedure" NUMERIC NOT NULL,
    "valid_until" NUMERIC NOT NULL,
    "side_effects" TEXT NOT NULL CHECK("side_effects" IN ('no', 'yes')),
    "performance" TEXT NOT NULL CHECK("performance" IN ('not yet known', 'high', 'low')),
    PRIMARY KEY("id"),
    FOREIGN KEY("pet_id") REFERENCES "pets"("id")
);

-- Represents medical tests
CREATE TABLE "tests" (
    "id" INTEGER,
    "pet_id" INTEGER,
    "test" TEXT NOT NULL,
    "reason" TEXT NOT NULL CHECK("reason" IN ('regular screening', 'prescribed by vet')),
    "comments" TEXT,
    "date_of_test" NUMERIC NOT NULL,
    "date_next" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("pet_id") REFERENCES "pets"("id")
);

-- Represents visits to vet clinic
CREATE TABLE "visits" (
    "id" INTEGER,
    "pet_id" INTEGER,
    "date_of_visit" NUMERIC NOT NULL,
    "clinic" TEXT,
    "clinic_rating" INTEGER CHECK("clinic_rating" IN ('0', '1', '2', '3', '4', '5')),
    "veterinarian" TEXT,
    "veterinarian_rating" INTEGER CHECK("clinic_rating" IN ('0', '1', '2', '3', '4', '5')),
    "reason" TEXT NOT NULL,
    "diagnosis" TEXT NOT NULL,
    "treatment" TEXT NOT NULL,
    "comments" TEXT,
    "date_next" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("pet_id") REFERENCES "pets"("id")
);

-- Create views
-- List of performed regular treatments for analysis of performance and side effects for a particular pet
CREATE VIEW "performed_treatments" AS
SELECT "procedure", "drug", "side_effects", "performance", "pets"."name" FROM "treatments"
JOIN "pets" ON "treatments"."pet_id" = "pets"."id";

-- List of conducted tests
CREATE VIEW "conducted_tests" AS
SELECT "test", "reason", "comments", "pets"."name" FROM "tests"
JOIN "pets" ON "tests"."pet_id" = "pets"."id";

-- Rating of vet clinics / veterinarians based on history of visits to clinics
CREATE VIEW "rating" AS
SELECT "clinic", "clinic_rating", "veterinarian", "veterinarian_rating", "reason", "comments", "pets"."name" FROM "visits"
JOIN "pets" ON "visits"."pet_id" = "pets"."id";

-- Create indexes
CREATE INDEX "treatments_search" ON "treatments" ("procedure", "drug");
CREATE INDEX "tests_search" ON "tests" ("test");
