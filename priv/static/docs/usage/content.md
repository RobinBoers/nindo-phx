# Content on Nindo

## Markdown

Nindo posts are written in markdown.

> Markdown is a lightweight markup language for creating formatted text using a plain-text editor. John Gruber and Aaron Swartz created Markdown in 2004 as a markup language that is appealing to human readers in its source code form.[9] Markdown is widely used in blogging, instant messaging, online forums, collaborative software, documentation pages, and readme files.

&mdash; [Wikipedia](https://en.wikipedia.org/wiki/Markdown)

Markdown is also used in Whatsapp, Discord, Slack, GitHub, Reddit and many other existing sites, so most people will already be familiar with it (but many don't know it's called markdown). It's converted to HTML using `HtmlSanitizeEx` when displayed on Nindo or exported in an RSS feed, but it is also accessible via the simple [Markdown API](markdown-api.md)

## RSS

Nindo exports all its content as RSS feeds. An RSS feed is a way to share content with other sites. It allows multiple Nindo instances to share content and it also allows users to follow content creators on Nindo in their own RSS reader without a Nindo account.

### Endpoints

Nindo has RSS feeds for users and comments. They can be found at:

- `/feed/:username`
- `/feed/blog`
- `/feed/post/:id/comments`

## Preferences

Below every posts there are multiple icons to share the post with your friends or set preferences. The font icon allows you to set the font the post is displayed in. Available fonts are:

- Sans font (system)
- Merriweater
- Helvetica
- Ubuntu Mono
