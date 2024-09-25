
## 💡 Lab Link: [Google Apps Script: Access Google Sheets, Maps & Gmail in 4 Lines of Code - GSP235](https://www.cloudskillsboost.google/focuses/3688?parent=catalog)

## 🚀 Lab Solution [Watch Here](https://youtu.be/FInwHT5u3lA)

---

### ⚠️ Disclaimer
- **This script and guide are provided for  the educational purposes to help you understand the lab services and boost your career. Before using the script, please open and review it to familiarize yourself with Google Cloud services. Ensure that you follow 'Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.**

### ©Credit
- **DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏

---

- **1. 🚨On the blank spreadsheet, click into the first cell in the upper left-hand corner (A1). It should be in column A and row 1**:

```
28 Snowbird Lane, Wasilla,ak, 99683  United States
```

- **2. 🚨From the top menu bar, select Extensions > Apps Script.**

- **3🚨The file `Code.gs` provides `"template"` code and doesn't do much. Copy the code below and paste it in the editor window to replace the template code. Then update `<YOUR_EMAIL>` with lab provided user email**:

```
function sendMap() {
    var sheet = SpreadsheetApp.getActiveSheet();
    var address = sheet.getRange("A1").getValue();
    var map = Maps.newStaticMap().addMarker(address);
    GmailApp.sendEmail("<YOUR_EMAIL>", "Map", 'See below.', {attachments:[map]});
}
```

### Congratulations, you're all done with the lab 😄

---

### 🌐 Join our Community

- **Join our [Discussion Group](https://t.me/Techcpschat)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps)** <img src="https://github.com/user-attachments/assets/6ee41001-c795-467c-8d96-06b56c246b9c" alt="icon" width="25" height="25">
- **Join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)** <img src="https://github.com/user-attachments/assets/aa10b8b2-5424-40bc-8911-7969f29f6dae" alt="icon" width="25" height="25">
- **Join our [Telegram Channel](https://t.me/Techcps)** <img src="https://github.com/user-attachments/assets/a4a4b767-151c-461d-bca1-da6d4c0cd68a" alt="icon" width="25" height="25">
- **Follow us on [LinkedIn](https://www.linkedin.com/company/techcps/)** <img src="https://github.com/user-attachments/assets/b9da471b-2f46-4d39-bea9-acdb3b3a23b0" alt="icon" width="25" height="25">

### Thanks for watching and stay connected :)
