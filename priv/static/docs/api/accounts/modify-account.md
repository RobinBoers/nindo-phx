# Modify account

Used to update user preferences.

**URL** : `/accounts/:username`

**Method** : `PUT`

**Auth required** : YES

**Data constraints** :

```json
{
    "key": "[string]",
    "value": "[string]"
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

### Unauthorized

**Condition** : Not authorized

**Code** : `403 UNAUTHORIZED`

### Other errors

**Condition** : If something went wrong updating the account with one of these reasons:

- Invalid key
- Invalid value

**Code** : `400 BAD REQUEST`

**Content** :

```json
{
    "message": "Error: something went wrong."
}
```
