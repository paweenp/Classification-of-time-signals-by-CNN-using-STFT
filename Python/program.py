# Program executing a project
from convNet import createCNN, train
import numpy as np
import glob
import cv2
import matplotlib as plt

#!TODO Refactoing 

# import images, labels and separate them to 
# 1.training images 
# 2.validation images
# 3.test images

# load images from path and contruct a pile of images
n = 0
imgs = []
img_labels = []
files = glob.glob("C:\workspace\FRA-UAS\semester2\CompInt\CompInt-Project-T3\MATLAB\DownsampledObjects\Object1\*.jpg")
for item in files:
    img = cv2.imread(item)
    imgs.append(img)
    n = n + 1 # manipulate labels ( temp )
    if n%2 == 0:
        img_labels.append(1)
    else:
        img_labels.append(2)
        

# create image labels with same size as images 
#!TODO Find a random method and make this into dynamic 
training_imgs = np.array(imgs[1:200])
test_imgs = np.array(imgs[201:315])
training_labels = np.array(img_labels[1:200])
test_labels = np.array(img_labels[201:315])

# create and train Network
epoch_num = 10
network = createCNN(66, 88, 3)

network.summary()

trainNetwork = train(network, training_imgs, training_labels, test_imgs, test_labels, epoch_num, 2)

# Evaluation and Plot accuracy 
plt.plot(trainNetwork.trainNetwork['accuracy'], label='accuracy')
plt.plot(trainNetwork.trainNetwork['val_accuracy'], label = 'val_accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.ylim([0.5, 1])
plt.legend(loc='lower right')

# test_loss, test_acc = model.evaluate(test_images,  test_labels, verbose=2)