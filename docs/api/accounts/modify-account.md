# Modify account

Used to update user preferences.

**URL** : `/accounts/:username`

**Method** : `PUT`

**Auth required** : YES

**Data constraints** :

```json
{
    "key": "[string]",
    "value": "[string]",
    "token": "[string]"
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

**Condition** : If something went wrong updating the account with one of these reasons:

- Invalid key
- Invalid value
- Invalid token

**Code** : `400 BAD REQUEST`

**Content** :

```json
{
    "message": "Error: something went wrong."
}
```
