RuBot![alt text](http://i.imgur.com/Hs1iwYc.png?1 "RuBot logo")
=====

An expirement in onboarding for the Udacity Rubyists Slack team! If desired, RuBot can be cloned, customized, and deployed to suit the needs of your Slack team. 

See [RuBot's UI](https://rubot.udacity.com/).

## What does the bot do?

1. **Messages**

  Schedule messages to be sent to new Slack team members based on how long they have been a member. For example, one message could immediately welcome the user and offering an orientation while another is scheduled to offer 1:1 appointments 5 days later.

  The goal is to schedule messages at strategic intervals in hopes of increasing engagement and retention.

2. **Interactions**

  Set user input, or trigger words, and a response. The bot will respond whenever somebody sends the trigger word to it.

    ![Alt text](https://github.com/udacity/RuBot/blob/master/app/assets/images/rubotspeak.png)

3. **Blasts**

  Send a direct message from the bot to every user on your team.

4. **Etc.**

  The UI also contains information about every user on your team and some metrics about bot usage.

  See [RuBot's UI](https://rubot.udacity.com/)


## Customize the bot for your own team.

RuBot is a Rails app built to be (somewhat) easily reproduced and customized. To work on the application, you will need to have Ruby, Rails, and Postgres installed. If you want to deploy to berlioz you will also need to have docker installed and a dockerhub account. You will need to email steven.worley@udacity.com for more information.

To set up your own custom version of RuBot, follow these instructions:

1. **Create your bot user on Slack**

  You'll need Slack admin priveledges to do this. Visit this link: [Create bot user](https://my.slack.com/services/new/bot)

  Follow the setup instructions. You don't need to set anything except for the name and upload an image.

  Copy the API token and keep in a safe place.

2. **Clone the repository**

  `git clone https://github.com/udacity/RuBot.git`

3. **Set ENV variables**

  create a file named `application.yml` in the project root directory containing the following text:

    ```
    SLACK_TOKEN: "<put your token here>"
    CLIENT_ID: "<your google oauth client id>"
    CLIENT_SECRET: "<your google oauth client secret>"
    ```

  SKIP to the next step unless you're deploying to berlioz:

  create a file named `.env-production` in the project root directory containing the following text:

    ```
    CONDUCTOR_API_KEY=<conductor api key>
    RAILS_ENV=production
    SLACK_TOKEN=<put your slack token here>
    CLIENT_ID=<your google oauth client id>
    CLIENT_SECRET=<your google oauth client secret>
    SECRET_KEY_BASE=<secret key base>
    ```

  create a file named `.env-development` in the project root directory containing the following text:

    ```
    RAILS_ENV=development
    SLACK_TOKEN=<put your slack token here>
    CLIENT_ID=<your google oauth client id>
    CLIENT_SECRET=<your google oauth client secret>
    DB_HOST=<your docker machine ip or blank>
    DB_PORT=<your docker machine port or blank>
    DB_PASSWORD=<your postgress db password>
    DB_USER=<your postgress db user>
    ```

4. **Customize**

    In `/config/application.rb` replace "RuBot" with your bot's name in this line:
    `Rails.application.config.client_name = "RuBot"`

    You will probably want to replace some of the images in `/app/assets/images/` with your own. 

## Deployment instructions

Deploying to berlioz will require assistance from our friendly engineering team. Please email me and / or somebody on the engineering team for help.

export $(cat .env-production | xargs) && make deploy

## Contributors

The project was created by Fuzz Worley at the suggestion of Walter Latimer after hearing about 18F's [Dolores Landingham bot](https://18f.gsa.gov/2015/12/15/how-bot-named-dolores-landingham-transformed-18fs-onboarding/).

Contributors include Fuzz Worley, Colt Steele, and Angel Perez.
