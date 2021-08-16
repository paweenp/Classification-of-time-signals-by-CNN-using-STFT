from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Conv2D, MaxPool2D
from keras.layers import Activation, Dropout, Flatten, Dense
from keras import backend as K
import numpy as np
from keras.preprocessing import image

# image dimensions

img_width, img_height = 156, 156
train_data_dir = 'C:/Users/MukitKhan/Desktop/CompInt-Project-T3/Data/Train'
validation_data_dir = '../Data/validation'
nb_train_samples = 320
nb_validation_samples = 5
epochs = 1
batch_size = 4

if K.image_data_format() == 'channels_first':
    input_shape = (3, img_width, img_height)
else:
    input_shape = (img_width, img_height, 3)
train_datagen = ImageDataGenerator(
    rescale=1. / 255,
    shear_range=0.2,
    zoom_range=0.2,
)

test_datagen = ImageDataGenerator(rescale=1. / 255)
train_generator = train_datagen.flow_from_directory(
    train_data_dir,
    target_size=(img_width, img_height),
    batch_size=batch_size,
    class_mode='binary')
validation_generator = test_datagen.flow_from_directory(
    validation_data_dir,
    target_size=(img_width, img_height),
    batch_size=batch_size,
    class_mode='binary')

############# CNN ###############
model = Sequential()
model.add(Conv2D(32, (3, 3), input_shape=input_shape))
model.add(Activation('relu'))
model.add(MaxPool2D(pool_size=(2, 2)))
model.summary()
model.add(Conv2D(64, (3, 3)))
model.add(Activation('relu'))
model.add(MaxPool2D(pool_size=(2, 2)))
model.add(Flatten())
model.add(Dense(64))
model.add(Activation('relu'))
model.add(Dropout(0.5))
model.add(Dense(1))
model.add(Activation('sigmoid'))

model.summary()

model.compile(loss='binary_crossentropy',
              optimizer='rmsprop',
              metrics=['accuracy'])

model.fit(train_generator,
          steps_per_epoch=int(8000 / batch_size),
          epochs=10,
          batch_size=4,
          validation_data=validation_generator,
          validation_steps=int(2000 / batch_size))

model.save_weights('first_try.h5')
img_pred = image.load_img('../Data/validation/Object1/216.jpg', target_size=(img_width, img_height))
img_pred = image.img_to_array(img_pred)
img_pred = np.expand_dims(img_pred, axis=0)
rslt = model.predict((img_pred))
print(rslt)
if rslt[0][0] == 1:
    prediction = "object1"
else:
    prediction = "no object1"
