# Create account

Used to create an user account.

**URL** : `/accounts`

**Method** : `PUT`

**Auth required** : NO

**Data constraints** :

```json
{
    "username": "[string]",
    "password": "[string]",
    "email": "[string]"
}
```

## Success Response

**Code** : `201 CREATED`

**Content example** :

```json
{
    "message": "Success! You can close this tab now."
}
```

## Error Response

**Condition** : If something went wrong creating the account with one of these reasons:

- Username already exists (you can check using the [User profile endpoint](get-account.md))
- Email invalid

**Code** : `400 BAD REQUEST`

**Content** :

```json
{
    "message": "Error: something went wrong."
}
```
