# New post

Used to publish a new post.

**URL** : `/posts`

**Method** : `PUT`

**Auth required** : YES

**Data constraints** :

```json
{
    "title": "[string]",
    "body": "[string]"
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

**Condition** : Not authorized

**Code** : `403 UNAUTHORIZED`
