# Authentication

Used to obtain an access token.

**URL** : `/login`

**Method** : `POST`

**Auth required** : NO(T YET)

**Data constraints** :

```json
{
    "username": "[string]",
    "password": "[string]"
}
```

## Success Response

**Code** : `202 ACCEPTED`

**Content example** :

```json
{
    "message": "Success! You can close this tab now.",
    "token": "ABC"
}
```

## Error Response

**Condition** : If something went wrong generating access token with one of these reasons:

- Account doesn't exist
- Password incorrect

**Code** : `400 BAD REQUEST`

**Content** :

```json
{
    "message": "Error: something went wrong."
}
```
