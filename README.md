# README

## What is done
An app that works for 1 client session with 1 API key to draw even updates from the Calendly Webhook and display them in a basic table in the browser. My approach includes the start of a subscription on load of '/.' The webhook will push to an endpoint that saves all event updates for the user in the database. A javascript fetch call (ES6 is required) retrieves latest 10 event updates on server boot and then updates every 30 seconds with newly created event updates. If you need to clear the subscription to the webhook, load '/delete' in the browser.


## What is not done
Tests.
Pretty UI.
Error handling around the API endpoints.

To be honest, I just ran out of time with setup and remembering all the ruby/rails magic.

## Would have, Could have, Should have
It looks like Rails 5 added channels and magical support for Webhooks. I am unfamiliar with these new updates and focused on showcasing what I do know. In a different context, I would have learned these new updates and figured out how to leverage them to provide a better (and more scalable) solution. I also would have broken out the event controller since I am doing a lot of things all at once in there. The front end could also easily be a React app that more instant updates to the DOM over the native Javascript interval method.
