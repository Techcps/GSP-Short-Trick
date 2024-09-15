
## 💡 Lab Link: [TensorFlow: Qwik Start - GSP637](https://cloudskillsboost.google/focuses/7639?parent=catalog)

## 🚀 Lab Solution [Watch Here](https://youtu.be/Ljhk2F6Bu90)

---
## 💡 Press Ctrl+shift+v then Enter to run the following commands in Terminal

```
pip install google-cloud-logging

pip install ---upgrade protobuf

pip install --upgrade tensorflow

python --version

python -c "import tensorflow;print(tensorflow.__version__)"


cat > model.py <<'EOF_CP'
import logging
import google.cloud.logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2.handlers import setup_logging

cloud_logger = logging.getLogger('cloudLogger')
cloud_logger.setLevel(logging.INFO)
cloud_logger.addHandler(CloudLoggingHandler(cloud_logging.Client()))
cloud_logger.addHandler(logging.StreamHandler())

import tensorflow as tf
import numpy as np

xs = np.array([-1.0, 0.0, 1.0, 2.0, 3.0, 4.0], dtype=float)
ys = np.array([-2.0, 1.0, 4.0, 7.0, 10.0, 13.0], dtype=float)

model = tf.keras.Sequential([tf.keras.layers.Dense(units=1, input_shape=[1])])

model.compile(optimizer=tf.keras.optimizers.SGD(), loss=tf.keras.losses.MeanSquaredError())

model.fit(xs, ys, epochs=500)
cloud_logger.info(str(model.predict(np.array([10.0]))))
EOF_CP

python model.py

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

---

### 🚨NOTE: copyright by Google Cloud
- **This script doesn't belong to this page, it has been edited and shared for the purpose of Educational. DM for credit or removal request (no copyright intended) ©All rights and credits for the original content belong to Google Cloud.**
- **Credit to the respective owner [Google Cloud Skill Boost website](https://www.cloudskillsboost.google/)** 🙏

---
