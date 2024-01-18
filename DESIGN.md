# Design Document

By Anzhalika Dubasava

Video overview: https://youtu.be/-o069xSmR08

## Scope

Main purposes of the database:
* to manage family pets’ regular treatments (so as not to forget about deworming procedures, flea and tick treatments, annual vaccinations)
* to create pets’ medical history (and so not to miss something serious)
* to rate visited vet clinics and veterinarians (and so to find the best local clinic and veterinarian(s))

For this purposes I included in the scope of my database:
* (One family) Pets, including basic information
* (Common, regular) Treatments, including important information
* (Medical) Tests, including important information
* Visits (to a vet), including important information

Outside of the scope are:
* connections with pets belonging to different families
* financial details like price of procedures or drugs
* analysis of health dynamics

## Functional Requirements

A user is able to:
* perform CRUD operations for pets, treatments, tests and visits
* keep track of deadlines, plan procedures and visits
* keep track of drugs resulting in side effects or having low performance

The database does not support uploading files (with test results, for example). The database also does not use soft deletion.

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Pets

The `pets` table includes:

* `id`, which specifies the unique ID for the pet as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `type`, which specifies the pet's type (like *cat*, *dog*, *frog*) as `TEXT`.
* `name`, which specifies the pet's name. `TEXT` is used as it is appropriate for name fields.
* `date_of_birth`, which specifies the pet's date of birth. `NUMERIC` is used per SQLite documentation.

All columns are required and hence should have the `NOT NULL` constraint applied. Date of birth is crucial for choosing appropriate medical procedures and tests. If a user does not know the exact date of birth she or he should choose more or less adequate (having asked a veterinarian).

The `treatments` table includes:

* `id`, which specifies the unique ID for the treatment as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `pet_id`, which specifies the ID for the pet as an `INTEGER`. This column connected to `pets` table thus has the `FOREIGN KEY` constraint applied.
* `procedure`, which specifies the treatment name (like *vaccination*, *deworming*) as `TEXT`. Though most popular procedures could be under `CHECK` constraint I did not apply it as for different types of pets and for different pets the range of regular treatments can be wider.
* `drug`, which specifies the drug name. `TEXT` is used as it is appropriate for name fields.
* `date_of_procedure`, which specifies the date of the treatment. `NUMERIC` is used per SQLite documentation.
* `valid_until`, which specifies the expiration date of the treatment. `NUMERIC` is used per SQLite documentation.
* `side_effects`, which specifies presence or absence of side effects and has only two possible values: *no* and *yes*. `TEXT` is used together with `CHECK` constraint.
* `performance`, which specifies performance of a particular drug and has three possible values: *not yet known*, *high* and *low*. `TEXT` is used together with `CHECK` constraint.

All columns are required and hence should have the `NOT NULL` constraint applied. Columns `drug`, `side_effects` and `performance` are crucial for the future procedures. It is very important to pay attention to any observed side effects and performance of drugs (as there no drugs that are good for every pet).

The `tests` table includes:

* `id`, which specifies the unique ID for the test as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `pet_id`, which specifies the ID for the pet as an `INTEGER`. This column connected to `pets` table thus has the `FOREIGN KEY` constraint applied.
* `test`, which specifies the test name (like *common blood test*, *ultrasound*) as `TEXT`.
* `reason`, which specifies reason for the test. I decided to include just two reasons: *regular screening* and *prescribed by vet*, so `TEXT` is used together with `CHECK` constraint.
* `comments`, which specifies any comments user can leave after the test. `TEXT` is used as it is appropriate for comments. This is an optional field.
* `date_of_test`, which specifies the date of the test. `NUMERIC` is used per SQLite documentation.
* `date_next`, which specifies the date of next test. `NUMERIC` is used per SQLite documentation. This is an optional field (just from my experience).

All columns, except for those with optional fields, are required and hence should have the `NOT NULL` constraint applied.

The `visits` table includes:

* `id`, which specifies the unique ID for the visit as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `pet_id`, which specifies the ID for the pet as an `INTEGER`. This column connected to `pets` table thus has the `FOREIGN KEY` constraint applied.
* `date_of_visit`, which specifies the date of the visit. `NUMERIC` is used per SQLite documentation.
* `clinic`, which specifies the vet clinic name as `TEXT`. This is an optional field (if a user wants to rate clinics).
* `clinic_rating`, which specifies rating for the vet clinic with values from *0* to *5*, so `INTEGER` is used together with `CHECK` constraint. This is an optional field (if a user wants to rate clinics).
* `veterinarian`, which specifies the veterinarian name as `TEXT`. This is an optional field (if a user wants to rate veterinarians).
* `veterinarian_rating`, which specifies rating for the veterinarian with values from *0* to *5*, so `INTEGER` is used together with `CHECK` constraint. This is an optional field (if a user wants to rate veterinarians).
* `reason`, which specifies the reason for a visit as `TEXT` (complaints, observations of unusual behaviour etc.).
* `diagnosis`, which specifies the diagnosis as `TEXT`.
* `treatment`, which specifies the treatment (recommendations, medicine, tests, procedures etc.) as `TEXT`.
* `comments`, which specifies any comments user can leave after the visit. `TEXT` is used as it is appropriate for comments. This is an optional field.
* `date_next`, which specifies the date of next test. `NUMERIC` is used per SQLite documentation. This is an optional field as the next visit is not always required.

All columns, except for those with optional fields, are required and hence should have the `NOT NULL` constraint applied. Columns `reason`, `diagnosis` and `treatment` are crucial for medical history.

A `UNIQUE` constraint is not applied at all at the database (of course, except entities with primary/foreign key constraint).

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

[![](https://mermaid.ink/img/pako:eNplj0EKgzAQRa8SZq0ewJ1QC0ItpUqhkM2QjFVqjJgEWkzuXtN2UejshveYP38FoSVBDrTsBrwtqPjEttkXdXW4Mu-zLHh2KluWsx7NB8Y16DTVK2vPZdHW5TFyDoNh9Ji1Icms5vBvl00UhZ6kE_bnmvdvfqmaKgoK72QgAUWLwkFu763R5WB7UsQhZknq0I02poRNRWd185wE5HZxlICbJVr6doK8w9FQeAHQZUr3?type=png)](https://mermaid.live/edit#pako:eNplj0EKgzAQRa8SZq0ewJ1QC0ItpUqhkM2QjFVqjJgEWkzuXtN2UejshveYP38FoSVBDrTsBrwtqPjEttkXdXW4Mu-zLHh2KluWsx7NB8Y16DTVK2vPZdHW5TFyDoNh9Ji1Icms5vBvl00UhZ6kE_bnmvdvfqmaKgoK72QgAUWLwkFu763R5WB7UsQhZknq0I02poRNRWd185wE5HZxlICbJVr6doK8w9FQeAHQZUr3)

As detailed by the diagram:

* One family is capable of having 1 to many pets (if family has 0 pets it will not use the database).
* One pet can be exposed to 0 to many treatments.
* One pet can conduct 0 to many medical tests.
* One pet can make 0 to many visits to a vet.
* One treatment can be applied to 0 to many pets.
* One can be conducted by 0 to many pets.
* A particular visit is associated with one and only one pet.

## Optimizations

As typical queries are associated with treatments and tests, I created indexes on `procedure` and `drug` columns for table `treatments` and on `test` column for table `tests`. These columns are used both to access all treatments and tests and to make more particular searches (last tests, recent tests and so on).

Also, I created 3 views for particular frequent needs:
* list of performed regular treatments (*for analysis of performance and side effects for a particular pet*)
* list of conducted tests (*containing not all but most important information for quick analysis*)
* rating of vet clinics / veterinarians based on history of visits to clinics (*to provide more convenient environment for evaluating current ratings*)

## Limitations

The current schema assumes only one user (family). In future the database could be extended so that many users (families) could use it and share their ratings or other experience.
