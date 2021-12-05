# REST API

NindoPhx has an REST API to access accounts and posts. The API scope is `/api`.

## Open Endpoints

Open endpoints require no Authentication.

* [List accounts](api/accounts/list-accounts.md) : `GET /accounts`
* [Create account](api/accounts/create-account.md) : `PUT /accounts`
* [User profile](api/accounts/get-account.md) : `GET /accounts/:username`
* [List posts](api/posts/list-posts.md) : `GET /posts`
* [Sinlge post](api/posts/get-post.md) : `GET /posts/:id`
* [Login](api/login.md) : `POST /login`

## Private Endpoints

These endpoint require Authentication in the form of an token. A token can be obtained via the Login API described above.

* [Modify account](api/account/modify-account.md) : `PUT /accounts/:username`
* [Create post](api/posts/create-post.md) : `PUT /posts`
