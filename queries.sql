-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Find possible deadline for regular treatments
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "procedure", "drug", "date_of_procedure", "valid_until"
FROM "pets"
JOIN "treatments" ON "treatments"."pet_id" = "pets"."id"
WHERE "treatments"."valid_until" < (
    SELECT date('now')
    ORDER BY "valid_until"
);

-- Find possible deadline for medical tests
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "test", "reason", "date_of_test", "date_next"
FROM "pets"
JOIN "tests" ON "tests"."pet_id" = "pets"."id"
WHERE "tests"."date_next" < (
    SELECT date('now')
    ORDER BY "date_next"
);

-- Find upcoming regular treatments
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "procedure", "drug", "date_of_procedure", "valid_until"
FROM "pets"
JOIN "treatments" ON "treatments"."pet_id" = "pets"."id"
WHERE "treatments"."valid_until" > (
    SELECT date('now')
    ORDER BY "valid_until"
);

-- Find upcoming medical tests
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "test", "reason", "date_of_test", "date_next"
FROM "pets"
JOIN "tests" ON "tests"."pet_id" = "pets"."id"
WHERE "tests"."date_next" > (
    SELECT date('now')
    ORDER BY "date_next"
);

-- Find upcoming visits to vet clinic
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "date_of_visit", "reason", "diagnosis", "treatment", "date_next"
FROM "pets"
JOIN "visits" ON "visits"."pet_id" = "pets"."id"
WHERE "visits"."date_next" > (
    SELECT date('now')
    ORDER BY "date_next"
);

-- Show all regular treatments from latest to oldest
SELECT *
FROM "pets"
JOIN "treatments" ON "treatments"."pet_id" = "pets"."id"
ORDER BY "date_of_procedure" DESC;

-- Show 5 last regular treatments
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "procedure", "drug", "date_of_procedure", "valid_until"
FROM "pets"
JOIN "treatments" ON "treatments"."pet_id" = "pets"."id"
ORDER BY "date_of_procedure" DESC
LIMIT 5;

-- Show all medical tests from latest to oldest
SELECT *
FROM "pets"
JOIN "tests" ON "tests"."pet_id" = "pets"."id"
ORDER BY "date_next" DESC;

-- Show 5 last medical tests
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "test", "reason", "date_of_test", "date_next"
FROM "pets"
JOIN "tests" ON "tests"."pet_id" = "pets"."id"
ORDER BY "date_next" DESC
LIMIT 5;

-- Show all visits to vet clinic from latest to oldest
SELECT *
FROM "pets"
JOIN "visits" ON "visits"."pet_id" = "pets"."id"
ORDER BY "date_next" DESC;

-- Show 5 last visits to vet clinic
SELECT "pets"."type" AS "type", "pets"."name" AS "name", "date_of_visit", "reason", "diagnosis", "treatment", "date_next"
FROM "pets"
JOIN "visits" ON "visits"."pet_id" = "pets"."id"
ORDER BY "date_next" DESC
LIMIT 5;

-- Add a new pet
INSERT INTO "pets" ("type", "name", "date_of_birth")
VALUES ('frog', 'Pitty', '2023-11-27');

-- Add a new regular treatment
INSERT INTO "treatments" ("pet_id", "procedure", "drug", "date_of_procedure", "valid_until", "side_effects", "performance")
VALUES ('2', 'vaccination', 'Nobivac', '2023-05-17', '2024-05-16', 'no', 'high');

-- Add a new medical test
INSERT INTO "tests" ("pet_id", "test", "reason", "comments", "date_of_test", "date_next")
VALUES ('2', 'common blood test', 'regular screening', 'all ok', '2023-09-17', '2024-09-16');

-- Add a new visit to vet clinic
INSERT INTO "visits" ("pet_id", "date_of_visit", "clinic", "clinic_rating", "veterinarian", "veterinarian_rating", "reason", "diagnosis", "treatment", "comments", "date_next")
VALUES ('3', '2023-10-23', 'Aidavet', '5', 'Barkun', '5', 'vomiting', 'gastritis', 'nolpaza', '', '2023-10-30');

-- Show ratings of vet clinics and veterinarians
SELECT *
FROM "rating"
ORDER BY "veterinarian_rating" DESC;

-- Show performed regular treatments for analysis of performance and side effects for a particular pet
SELECT *
FROM "performed_treatments"
ORDER BY "name";

-- Show conducted tests to provide general picture
SELECT *
FROM "conducted_tests"
ORDER BY "name";

