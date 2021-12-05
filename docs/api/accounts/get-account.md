# Get account

Used to get a profile data for a specific user.

**URL** : `/accounts/:username`

**Method** : `GET`

**Auth required** : NO

**Data constraints** :

```json
{
    "username": "[string]"
}
```

## Success Response

**Code** : `200 OK`

**Content example** :

```json
{
    "id": 19,
    "username": "robinboers",
    "display_name": "Robin Boers",
    "profile_picture": "https://www.geheimesite.nl/images/profile.JPG",
    "description": "Ik ben webdesigner, PHP programmeur en tiener. Ik ben 14 jaar oud en ik woon in Maassluis. Ik zit momenteel in de derde en ik werk bij Qdentity.",
    "feeds": [
        { "feed": "www.duurzamemaassluizers.nl", "icon": "https://www.duurzamemaassluizers.nl/favicon.ico", "title": "Duurzame Maassluizers", "type": "wordpress" },
        { "feed": "webdevelopment-en-meer.blogspot.com", "icon": "https://webdevelopment-en-meer.blogspot.com/favicon.ico", "title": "Webdevelopment-En-Meer", "type": "blogger" },
        { "feed": "paars-blauw.blogspot.com", "icon": "https://paars-blauw.blogspot.com/favicon.ico", "title": "Paars-Blauw", "type": "blogger" },
        { "feed": "stupidstuffwastaken.blogspot.com", "icon": "https://stupidstuffwastaken.blogspot.com/favicon.ico", "title": "Stupid Codes", "type": "blogger" }
    ],
    "following": ["robinboers", "robin"]
}
```

## Error Response

**Condition** : If the user doesn't exist

**Code** : `404 NOT FOUND`

**Content** :

```json
null
```
