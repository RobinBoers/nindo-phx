# REST API

NindoPhx has an REST API to access accounts and posts. The API scope is `/api`.

_Note: the API is currently disabled in production because I didn't have the time to fully test it to make sure it is secure enough._

## Open Endpoints

Open endpoints require no Authentication.

* [List accounts](..//accounts/list-accounts.md) : `GET /accounts`
* [Create account](..//accounts/create-account.md) : `PUT /accounts`
* [User profile](../accounts/get-account.md) : `GET /accounts/:username`
* [List posts](../posts/list-posts.md) : `GET /posts`
* [Sinlge post](../posts/get-post.md) : `GET /posts/:id`
* [Login](login.md) : `POST /login`

## Private Endpoints

These endpoint require Authentication in the form of an token. A token can be obtained via the Login API described above and as a bearer token put in the request headers.

* [Modify account](../accounts/modify-account.md) : `PUT /accounts/:username`
* [Create post](../posts/create-post.md) : `PUT /posts`
