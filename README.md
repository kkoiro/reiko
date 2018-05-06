Reiko
=======

**reiko** helps us to manage foods in our refrigerator.
She is expected to use on slack.

---


### Installation & Configuration

1. Install required packages

nodejs, npm, sqlite3 are required to use reiko.

2. Register your reiko on your team

Click following below:
  Apps&integration ->
  hubot ->
  Add Configuration

3. Copy your app token to bin/hubot

From 'Browse Apps > Hubot > Edit configuration(your app)', you can find HUBOT_SLACK_TOKEN.
Copy and paste it as
```
  export HUBOT_SLACK_TOKEN="your-slack-app-token"
```
in bin/hubot.

4. Change the database name

Change the database name of databases/example.sqlite3.
```
  $ mv example.sqlite3 main.sqlite3
```


### Usage

At first, showing how to run 'reiko'.
You can easily run reiko to execute the command below:
```
  $ bin/hubot -a slack
```
To execute reiko as a service:
```
  $ nohup bin/hubot -a slack &
```

Next, explainig the commands.
If you type a command in the channel reiko attends, she reply some information following the command.

- へるぷ

  You can see what kind of commands reiko has.
  
- りすと

  Reiko check our refrigerator's inventory.
  
- とうろく food_name date[YYYYMMDD]

  Reiko register what you bought and its expiration date.
  
- さくじょ id

  You can delete registered record if you finish up foods.
