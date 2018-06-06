# Walmart Parser

Simple parser for walmart products and comments.
Business logic moved to interactors to keep code clean and readable.
Sidekiq used for background processing which is better option for such kind of tasks.

We're keeping our records unique with their own walmart ids which inserting into our unique id field in DB.
