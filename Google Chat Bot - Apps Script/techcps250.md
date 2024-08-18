
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

## 🚨Click on the `Code.gs` file and remove the defualt code
- Add the below **code**
  
```
function onMessage(event) {
  console.log('Message received from user: ', event.message.sender.name);
  var message = event.message.text;
  var response = CardService.newTextParagraph().setText("You said: " + message);
  
  return CardService.newCardBuilder()
    .setHeader(CardService.newCardHeader().setTitle("Response"))
    .addSection(CardService.newCardSection().addWidget(response))
    .build();
}

function onAddToSpace(event) {
  console.log('Attendance Bot added in ', event.space.name);
  if (event.space.type === 'ROOM') {
    return {text: `Thanks for adding me to the room, ${event.space.displayName}!`};
  } else {
    return {text: 'Thanks for adding me to this DM!'};
  }
}

function onRemoveFromSpace(event) {
  console.log('Attendance Bot removed from ', event.space.name);
}

function onCardClick(event) {
  // Handle card click actions here.
  console.log('Card button clicked: ', event.action.parameters);
} 
```

## 🚨Click on the `Appsscript.json` file and remove the defualt code
- Add the below **code**
```
{
  "timeZone": "Asia/Kolkata",
  "dependencies": {},
  "exceptionLogging": "STACKDRIVER",
  "chat": {},
  "runtimeVersion": "V8"
}
```

## 🚨Click on the `Code.gs` file and remove the defualt code
- Add the below **code**
  
```
var DEFAULT_IMAGE_URL = 'https://goo.gl/bMqzYS';
var HEADER = {
  header: {
    title : 'Attendance Bot',
    subtitle : 'Log your vacation time',
    imageUrl : DEFAULT_IMAGE_URL
  }
};

/**
 * Creates a card-formatted response.
 * @param {object} widgets the UI components to send
 * @return {object} JSON-formatted response
 */
function createCardResponse(widgets) {
  return {
    cards: [HEADER, {
      sections: [{
        widgets: widgets
      }]
    }]
  };
}

/**
 * Responds to a MESSAGE event triggered
 * in Google Chat.
 *
 * @param event the event object from Google Chat
 * @return JSON-formatted response
 */
function onMessage(event) {
  var userMessage = event.message.text;

  var widgets = [{
    "textParagraph": {
      "text": "You said: " + userMessage
    }
  }];

  console.log('You said:', userMessage);

  return createCardResponse(widgets);
}
  function onRemoveFromSpace(event) {
    console.log('Attendance Bot removed from ', event.space.name);
  }
  
  function onCardClick(event) {
    // Handle card click actions here.
    console.log('Card button clicked: ', event.action.parameters);
  } 
```

## 🚨Click on the `Code.gs` file and remove the defualt code
- Add the below **code**
  
```
var DEFAULT_IMAGE_URL = 'https://goo.gl/bMqzYS';
var HEADER = {
  header: {
    title : 'Attendance Bot',
    subtitle : 'Log your vacation time',
    imageUrl : DEFAULT_IMAGE_URL
  }
};
  
/**
  * Creates a card-formatted response.
  * @param {object} widgets the UI components to send
  * @return {object} JSON-formatted response
  */
function createCardResponse(widgets) {
  return {
    cards: [HEADER, {
      sections: [{
        widgets: widgets
      }]
    }]
  };
}
  
var REASON = {
  SICK: 'Out sick',
  OTHER: 'Out of office'
};
/**
  * Responds to a MESSAGE event triggered in Google Chat.
  * @param {object} event the event object from Google Chat
  * @return {object} JSON-formatted response
  */
function onMessage(event) {
  console.info(event);
  var reason = REASON.OTHER;
  var name = event.user.displayName;
  var userMessage = event.message.text;

  // If the user said that they were 'sick', adjust the image in the
  // header sent in response.
  if (userMessage.indexOf('sick') > -1) {
    // Hospital material icon
    HEADER.header.imageUrl = 'https://goo.gl/mnZ37b';
    reason = REASON.SICK;
  } else if (userMessage.indexOf('vacation') > -1) {
    // Spa material icon
    HEADER.header.imageUrl = 'https://goo.gl/EbgHuc';
  }
  
  var widgets = [{
    textParagraph: {
      text: 'Hello, ' + name + '.<br>Are you taking time off today?'
    }
  }, {
    buttons: [{
      textButton: {
        text: 'Set vacation in Gmail',
        onClick: {
          action: {
            actionMethodName: 'turnOnAutoResponder',
            parameters: [{
              key: 'reason',
              value: reason
            }]
          }
        }
      }
    }, {
      textButton: {
        text: 'Block out day in Calendar',
        onClick: {
          action: {
            actionMethodName: 'blockOutCalendar',
            parameters: [{
              key: 'reason',
              value: reason
            }]
          }
        }
      }
    }]
  }];
  return createCardResponse(widgets);
}
  function onRemoveFromSpace(event) {
    console.log('Attendance Bot removed from ', event.space.name);
  }
  
  function onCardClick(event) {
    // Handle card click actions here.
    console.log('Card button clicked: ', event.action.parameters);
  }  
  
/**
  * Responds to a CARD_CLICKED event triggered in Google Chat.
  * @param {object} event the event object from Google Chat
  * @return {object} JSON-formatted response
  * @see https://developers.google.com/chat/reference/message-formats/events
  */
function onCardClick(event) {
  console.info(event);
  var message = '';
  var reason = event.action.parameters[0].value;
  if (event.action.actionMethodName == 'turnOnAutoResponder') {
    turnOnAutoResponder(reason);
    message = 'Turned on vacation settings.';
  } else if (event.action.actionMethodName == 'blockOutCalendar') {
    blockOutCalendar(reason);
    message = 'Blocked out your calendar for the day.';
  } else {
    message = "I'm sorry; I'm not sure which button you clicked.";
  }
  return { text: message };
}
  
var ONE_DAY_MILLIS = 24 * 60 * 60 * 1000;
/**
  * Turns on the user's vacation response for today in Gmail.
  * @param {string} reason the reason for vacation, either REASON.SICK or REASON.OTHER
  */
function turnOnAutoResponder(reason) {
  var currentTime = (new Date()).getTime();
  Gmail.Users.Settings.updateVacation({
    enableAutoReply: true,
    responseSubject: reason,
    responseBodyHtml: "I'm out of the office today; will be back on the next business day.<br><br><i>Created by Attendance Bot!</i>",
    restrictToContacts: true,
    restrictToDomain: true,
    startTime: currentTime,
    endTime: currentTime + ONE_DAY_MILLIS
  }, 'me');
}

/**
  * Places an all-day meeting on the user's Calendar.
  * @param {string} reason the reason for vacation, either REASON.SICK or REASON.OTHER
  */
function blockOutCalendar(reason) {
  CalendarApp.createAllDayEvent(reason, new Date(), new Date(Date.now() + ONE_DAY_MILLIS));
}

```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
