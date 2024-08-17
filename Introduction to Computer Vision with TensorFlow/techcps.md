
# Please like share & subscribe to [Techcps](https://www.youtube.com/@techcps) & join our [WhatsApp Community](https://whatsapp.com/channel/0029Va9nne147XeIFkXYv71A)

## 🚨 Go to Application Menu > File > New Text File
- Paste the below **code**
```
google-cloud-logging
tensorflow
tensorflow-datasets
numpy>=1.16.5,<1.23.0
scipy
protobuf==3.20.*
```
- Save as file name: **`requirements.txt`**

## 🚨 Go to Application Menu > Terminal > New Terminal
### 🚨How to paste the below commands to run it
- For Windows press **Ctrl+Shift+V** then allow pop-up message and press Enter Key
- For Mac press **Cmd+Shift+V** then allow pop-up message press Enter Key

## 🚨 Run the below script in the Terminal
```
python --version
python -c "import tensorflow;print(tensorflow.__version__)"
pip3 install --upgrade pip
/usr/bin/python3 -m pip install -r requirements.txt
/usr/bin/python3 -m pip install -U pylint --user
```

## 🚨 Go to Application Menu > File > New Text File
- Paste the below **code**

```
# Import and configure logging
import logging
import google.cloud.logging as cloud_logging
from google.cloud.logging.handlers import CloudLoggingHandler
from google.cloud.logging_v2.handlers import setup_logging
cloud_logger = logging.getLogger('cloudLogger')
cloud_logger.setLevel(logging.INFO)
cloud_logger.addHandler(CloudLoggingHandler(cloud_logging.Client()))
cloud_logger.addHandler(logging.StreamHandler())

# Import TensorFlow
import tensorflow as tf
# Import tensorflow_datasets
import tensorflow_datasets as tfds
# Import numpy
import numpy as np

# Define, load and configure data
(ds_train, ds_test), info = tfds.load('fashion_mnist', split=['train', 'test'], with_info=True, as_supervised=True)

# Values before normalization
image_batch, labels_batch = next(iter(ds_train))
print("Before normalization ->", np.min(image_batch[0]), np.max(image_batch[0]))

# Define batch size
BATCH_SIZE = 32

# Normalize and batch process the dataset
ds_train = ds_train.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)
ds_test = ds_test.map(lambda x, y: (tf.cast(x, tf.float32)/255.0, y)).batch(BATCH_SIZE)

# Examine the min and max values of the batch after normalization
image_batch, labels_batch = next(iter(ds_train))
print("After normalization ->", np.min(image_batch[0]), np.max(image_batch[0]))

# Define the model
model = tf.keras.models.Sequential([tf.keras.layers.Flatten(),
                                    tf.keras.layers.Dense(64, activation=tf.nn.relu),
                                    tf.keras.layers.Dense(10, activation=tf.nn.softmax)])

# Compile the model
model.compile(optimizer = tf.keras.optimizers.Adam(),
              loss = tf.keras.losses.SparseCategoricalCrossentropy(),
              metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])
model.fit(ds_train, epochs=5)
```
- Save as file name: **`model.py`**

## 🚨 Run the script in the Terminal
```
python model.py
```

- Add the following code to the **bottom of model.py**
```
cloud_logger.info(model.evaluate(ds_test))
```
- Save as file name: **`model.py`**

## 🚨 Run below the script in the Terminal
```
python model.py
```

- Add the following code to the **bottom of model.py**
```
# Save the entire model as a SavedModel.
model.save('saved_model')

# Reload a fresh Keras model from the saved model
new_model = tf.keras.models.load_model('saved_model')

# Summary of loaded SavedModel
new_model.summary()


# Save the entire model to a keras file.
model.save('my_model.keras')

# Recreate the exact same model, including its weights and the optimizer
new_model_keras = tf.keras.models.load_model('my_model.keras')

# Summary of loaded keras model
new_model_keras.summary()
```
- Save as file name: **`model.py`**

## 🚨 Run the below script in the Terminal
```
python model.py
```

## 🚨 Run the below script in the Terminal
```
curl -LO https://raw.githubusercontent.com/Techcps/GSP-Short-Trick/master/Introduction%20to%20Computer%20Vision%20with%20TensorFlow/techcps.sh

source techcps.sh
```

## Congratulations, you're all done with the lab 😄

# Thanks for watching :)
