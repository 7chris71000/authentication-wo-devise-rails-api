# README

## Overview

Tutorial followed https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api to implement the initial API with authorization capabilities.

Used the result of the API project to practice password protected values in a database. The initial motivation was to store values that cannot be accessed by anyone without the owners password. This restricts developers from looking at values with secret keys or running code manually.

Most of the work here was from scratch other than the methods in EncodingHelpers.

Item description is the password protected value.

Providing an incorrect password in the `encrypt_password` param will return an error. Not providing `encrypt_password` at all will return all values with encrypted values set to `null`.

## Parameter Examples

### Get items with password protected description in plain text.

```jsonc
// [GET] /items, [GET] /items/:id
{
  "encrypt_password": "password" // the users password, provided by the user
}
```

### Create item with password protected description.

```jsonc
// [POST] /items
{
  "item": {
    "name": "testName", // non password protected value
    "price_cents": 123, // non password protected value
    "description": "description text" // plain text description provided by the user
  },
  "encrypt_password": "password" // the users password, provided by the user
}
```
