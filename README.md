# Sats 4 Likes Bot

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e3912b0d0e3f43de8e9bc481b98d50c8)](https://app.codacy.com/gh/KoalaSat/sats-4-likes-bot?utm_source=github.com&utm_medium=referral&utm_content=KoalaSat/sats-4-likes-bot&utm_campaign=Badge_Grade_Settings)

This app is an automatic tasker and claimer for https://www.sats4likes.com. It has been build by reverse-engineering the app so it can review the list of tasks and automatically interact with the specific service API to complete the requested task. Once it's done, it claims to sats4likes the reward.

## Getting Started

Go to `./app/init.rb`. Those are the tokens you need for running the app.

I could have note down here a detailed description about how to obtain each of them, but where is the fun? Go and earn those sats :)

## Running

### Manual

You can manually trigger a complete check of tasks on your machine.

```
bundle install
bundle exec rake run
```

### Docker

The app is ready to be triggered every 25 hours by a cronjob on a docker instance.

```
docker-compose up -d
```

## Some Features to Work On

- [ ] ~~Integrationm with YouTube service~~ (YouTube blocks sats4likes app)
- [ ] Detect when a task is done before claiming it to the API
- [ ] Persist invalid tasks so they are not claimed again
- [ ] Integration with a node to claim channel requests 

------

Made with 🐨 by https://github.com/koalasat
