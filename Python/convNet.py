# Convolutional Network Class
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

class convNet:
    
# Construct CNN Model
def createCNN(width, height, channel):

    model = keras.Sequential()

    model.add(keras.Input(shape=(width, height, channel)))  # 88x66 RGB images

    model.add(keras.layers.Conv2D(3, 8, stride=(1, 1), padding="valid", ))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.ReLU())

    model.add(keras.layers.MaxPool2D(pool_size=(2, 2), strides=(2, 2)))

    model.add(keras.layers.Conv2D(3, 16, stride=(1, 1), padding="valid", ))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.ReLU())

    model.add(keras.layers.MaxPool2D(pool_size=(2, 2), strides=(2, 2)))

    model.add(keras.layers.Conv2D(3, 32, stride=(1, 1), padding="valid", ))
    model.add(keras.layers.BatchNormalization())
    model.add(keras.layers.ReLU())

    model.add(keras.layers.LocallyConnected2D(3))
    model.add(keras.layers.Softmax())
    # classificationLayer not included --> still observing the effect

    return model

# Train a Network
def train(model, train_images, train_labels, validation_images, test_images, test_labels, epochs_num, batch_size_num):

    callbacks = [keras.callbacks.ModelCheckpoint("save_at_{epoch}.h5"), ]

    model.compile(optimizer='sgd',
                  loss=keras.losses.SparseCategoricalCrossentropy(
                      from_logits=True),
                  metrics=['accuracy'])

    trainModel = model.fit(train_images,
                           train_labels,
                           epochs=epochs_num,
                           validation_data=(test_images, test_labels))

    return trainModel
