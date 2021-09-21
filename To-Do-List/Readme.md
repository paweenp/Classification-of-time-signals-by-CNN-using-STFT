# To-Do-List

Delegates works.

## Work assigned to Mahdieh, Rabiul ----------------------------------------------------------

I just need you two to focus on Introduction. Make it works. I will review it. ( Read from Preprocessing -> Evaluation)

*** (Rabiul I need you to help Mahdieh and I mean it, it's already too late for you to learn coding now. There won't be enough time. Talk to her and help her.)


## Preprocessing

In our method, we generate spectrogram as images. However, the main process is Short-Time-Fourier-Transform (STFT), which require window in operation. We need to come up with the best suitable window length and type. Right now, basing on our observations, hamming windows is the best, but I am not quite sure about the size yet (right now we are using 256, based on my guess). Then you need to find the papers to support that idea and write it into introduction. (Do not forget to cite them)

## Training Process

In our Process, we feed spectrogram as Images into our CNN model, which we already constructed beforehands. Our CNN model then will adjust according to the inputs. Finally after training for some times, we will get the fine model which can classify each objects (which is unlearned!! There are two datasets for each object, we separated them to the training set and the validate set).

## Evaluation

We will use confusion matrix to compute Accuracy, Precision, F1-Score, and conclude if our model works. (We have to make it work)

*** If you read from each website or paper. put the link in the paper as references too. It's super important ***

-------------------------------------------------------------------------------------------

## Work assigned to Mukit, Paween ----------------------------------------------------------

## Algorithm 

In my idea right now, I have two proposal. 
1.  If we use MATLAB, we have to find the way to use it efficiently. Most of deeper level functions are prohibit for us to see. We may have to read their papers and conclude from there.

2.  Use Python.

## Execute Experiment

You and I know this is not a hard work, after everything is clear or quite clear, we can run the loop through all the code to make experiment.

In my opinion, we can play with two things. Preprocessing with different window size (but there's less impact from there). Or training with different method. 1.) Sequentially (Obj1 -> Obj2 -> Obj3 ) 2.Sparsely  (Combine all of them and train). Then we can compare the results between them

From what I read, CNN model construction is basing on trial and errors, I think there's no rule in creating one. Most people use the default one and it works, I hope that's the case for us.

## Experiment Result

This part will based on previous part.

## Discussion and Conclusion

This part I will try to come up after seeing the result.

## Reference 

This part can be done at last

-----------------------------------------------------------------------------------

