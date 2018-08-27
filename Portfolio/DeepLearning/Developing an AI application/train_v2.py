# The project is breaken down to the following three parts:
# 1. Load and preprocess the image dataset
# 2. Train the image classifier on your dataset
# 3. Use the trained classifier to predict image content

# import needed library

# Imports common Python library
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import time

# Imports pytorch
import torch
from torch import nn # import neural network
from torch import optim # import optimization
import torch.nn.functional as F
from torchvision import datasets, transforms, models
from collections import OrderedDict

# Imports other python file for using fuctions
import json

# import the Image library
from PIL import Image

# import argparse library
import argparse

# Part 1: load the dataset
def load_dataset(data_dir):

    '''
    Purpose: this function is for preparing datasets for the training dataset.
    Parameter: data_dir - ask for data directory location
    
    Return:
    trainloader: normalized training dataset with RandomRotation 30, RandomResizedCrop 224 and RandomHorizontalFlip
    testloader: normalized testing dataset with Resize(256), CenterCrop(224)
    valiloader: normalized validation dataset with Resize(256), CenterCrop(224)
    class_to_idx: classes of the image datasets
    '''

    train_dir = data_dir + '/train'
    valid_dir = data_dir + '/valid'
    test_dir = data_dir + '/test'

    # Define your transforms for the training, validation, and testing sets
    train_transforms = transforms.Compose([transforms.RandomRotation(30),
                                           transforms.RandomResizedCrop(224),
                                           transforms.RandomHorizontalFlip(),
                                           transforms.ToTensor(),
                                           transforms.Normalize([0.485, 0.456, 0.406],[0.229, 0.224, 0.225])])

    test_transforms = transforms.Compose([transforms.Resize(256),
                                          transforms.CenterCrop(224),
                                          transforms.ToTensor(),
                                          transforms.Normalize([0.485, 0.456, 0.406],[0.229, 0.224, 0.225])])

    vali_transforms = transforms.Compose([transforms.Resize(256),
                                          transforms.CenterCrop(224),
                                          transforms.ToTensor(),
                                          transforms.Normalize([0.485, 0.456, 0.406],[0.229, 0.224, 0.225])])

    # Load the datasets with ImageFolder
    train_data = datasets.ImageFolder(train_dir, transform = train_transforms)
    test_data = datasets.ImageFolder(test_dir, transform = test_transforms)
    vali_data = datasets.ImageFolder(valid_dir, transform = vali_transforms)

    # Using the image datasets and the trainforms, define the dataloaders
    trainloader = torch.utils.data.DataLoader(train_data, batch_size=64, shuffle=True)
    testloader = torch.utils.data.DataLoader(test_data, batch_size = 32, shuffle = True)
    valiloader = torch.utils.data.DataLoader(vali_data, batch_size = 32, shuffle = True)

    class_to_idx = train_data.class_to_idx
    
    return trainloader, testloader, valiloader, class_to_idx

# Part 2: Building and training the classifier

# A. choose a pretrained network
def choose_network(arch):
    '''
    Purpose: choose pretrained netowrk from pytorch
    parameter: arch - name of the pretained network 
    return: model
    '''

    # Only download the model you need, kill program if none of the following models isn't passed

    if arch == 'vgg13':
        model = models.vgg13(pretrained = True)
        input_size = 25088
        print("Pretrained model is vgg13")
    elif arch == 'densenet121':
        model = models.densenet121(pretrained = True)
        input_size = 1024
        print("Pretrained model is densenet121")
    else:
        print('{} architecture not recognized. Supported args: \'vgg\' or \'densenet\''.format(arch))
        sys.exit()
    return model, input_size
    
# B. Define a new, untrained feed-forward network as a classifier, using ReLU activations and dropout
def create_classifier(model, input_size, output_size, hidden_layers, class_to_idx, learning_rate = 0.001, drop_p=0.3):
    '''
    Purpose: Define a new, untrained feed-forward network as a classifier, using ReLU activations and dropout
    Parameter:
    model: the pretained model
    input_size: input size of the network
    output_size: output size of the network
    class_to_idx: class_to_idx from train dataset
    learning_rate: float between 0 and 1, learning rate default is 0.001
    drop_p: float between 0 and 1, dropout probability, default is 0.3

    Return:
    model: new classify model
    criterion: loss criterion
    optimizer: model optimizer

    '''
    #Freeze parameters so we don't backprop through them
    for param in model.parameters():
        param.requires_grad = False

    hidden_layers.append(output_size)
    
    layers = nn.ModuleList([nn.Linear(input_size,hidden_layers[0])])
    layer_sizes= zip(hidden_layers[:-1], hidden_layers[1:])
    layers.extend([nn.Linear(h1, h2) for h1, h2 in layer_sizes]) 

    # create an empty Orderdict
    net_layers = OrderedDict()

    for x in range(len(layers)):
        layerid = x + 1
        if x == 0:
            net_layers.update({'fc{}'.format(layerid): layers[x]})
            net_layers.update({'relu{}'.format(layerid): nn.ReLU()}),
            net_layers.update({'dropout{}'.format(layerid): nn.Dropout(p=drop_p)})
        else:
            net_layers.update({'fc{}'.format(layerid): layers[x]}),
            net_layers.update({'relu{}'.format(layerid):nn.ReLU()}),
            net_layers.update({'dropout{}'.format(layerid): nn.Dropout(p = drop_p)})
    
        if layerid == len(layers):
            del net_layers['relu{}'.format(layerid)]
            del net_layers['dropout{}'.format(layerid)]

    net_layers.update({'output':nn.LogSoftmax(dim=1)})

    #Define classifier
    classifier = nn.Sequential(net_layers)
    
    # assign new classifier to model
    model.classifier = classifier
    model.class_to_idx = class_to_idx

    # define criterion and optimizer
    criterion = nn.NLLLoss()
    optimizer = optim.Adam(model.classifier.parameters(), lr = learning_rate)
    
    return model, criterion, optimizer

# C. train the classifer

# part 1: create a validation function
def validation(model, device, criterion, dataset):
    
    '''
    Purpose: to validate a dataset using a training model
    Input: 
    model: model for validation
    device: indicate whether a gpu or cpu is use
    criterion: criterion of the network for the training
    dataset: dataset used for validation
    
    Return: 
    test_loss: testing loss
    accuracy: validation accuracy
    '''

    # device depends on the train_classifier function below
    model.to(device)

    accuracy = 0
    test_loss = 0

    for inputs, labels in iter(dataset):
        inputs, labels = inputs.to(device), labels.to(device)

        output = model.forward(inputs)
        test_loss += criterion(output, labels).item()

        ## Calculating the accuracy
        # Model's output is log-softmax, take exponential to get the probabilities
        ps = torch.exp(output)

        # Class with highest probability is our predicted class, compare with true label
        equality = (labels.data == ps.max(1)[1])

        # Accuracy is number of correct predictions divided by all predictions, just take the mean
        accuracy += equality.type_as(torch.FloatTensor()).mean()

    return test_loss, accuracy

def train_classifier(model, trainloader, valiloader, criterion, optimizer, epochs, is_gpu, print_every = 40):
    
    '''
    Purpose: to train a model 
    Input
    model: the model used for training
    trainloader: the training dataset
    valiloader: the validation dataset
    criterion: model loss criterion
    optimizer: optimizer method for the model
    epochs: # of epoch
    is_gpu: indicate whether the model is trained under gpu
    print_every: print out log
    
    Return: 
    model: the final trained model
    '''
    
    steps = 0

    model.train()
    
    #Selects CUDA processing if gpu == True and if the environment supports CUDA
    if is_gpu and torch.cuda.is_available(): 
        device = "cuda"
        print("Current training is under GPU")
    else: 
        device = "cpu"
        print("Current training is under CPU")
    
    model = model.to(device)

    for e in range(epochs):
        running_loss = 0

        for inputs, labels in iter(trainloader):
            steps +=1

            inputs, labels = inputs.to(device), labels.to(device)
            optimizer.zero_grad()

        # Forward and backward passes
            outputs = model.forward(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

            running_loss += loss.item()

            if steps % print_every == 0:

                # Model in inference mode, dropout is off
                model.eval()

                # Turn off gradients for validation, will speed up inference
                with torch.no_grad():
                    test_loss, accuracy = validation(model=model, device = device, criterion=criterion, dataset = valiloader)

                print("Epoch: {}/{}.. ".format(e+1, epochs),
                      "Training Loss: {:.3f}.. ".format(running_loss/print_every),
                      "Validation Loss: {:.3f}.. ".format(test_loss/len(valiloader)),
                      "Validation Accuracy: {:.3f}".format(accuracy/len(valiloader)))

                running_loss = 0

            # Make sure dropout and grads are on for training
                model.train()

    return model

def test_classifier(model, criterion, dataset, is_gpu):
    
    '''
    Purpose: Test the model 
    Input:
    model: model used for testing
    criterion: criterion
    dataset: dataset for testing
    is_gpu: indicate whether the model is tested under gpu
    '''
    model.eval()
    
    #Selects CUDA processing if gpu == True and if the environment supports CUDA
    if is_gpu and torch.cuda.is_available(): 
        device = torch.device("cuda")
        print("Current training is under GPU")
    else: 
        device = torch.device("cpu")
        print("Current training is under CPU")
    
    model = model.to(device)

    # model.eval()
    test_loss, accuracy = validation(model = model, device = device, criterion = criterion, dataset = dataset)
    print("Val. Accuracy: {:.3f}".format(accuracy/len(dataset)))
    print("Val. Loss: {:.3f}".format(test_loss/len(dataset)))

    pass

#Save the checkpoint
def save_model(input_size, output_size, hidden_layers, learning_rate, model_name, model, optimizer, epochs):
# TODO: Save the checkpoint
    checkpoint = {'input_size': input_size,
                  'output_size': output_size,
                  'hidden_layers': hidden_layers,
                  'learning_rate': learning_rate,
                  'arch': model_name,
                  'state_dict': model.state_dict(),
                  'optimizer': optimizer.state_dict(),
                  'epoch': epochs,
                  'classifier': model.classifier,
                  'class_to_idx': model.class_to_idx}   
    
    save_path = 'checkpoint.pth'
    torch.save(checkpoint, 'checkpoint.pth')

    pass

def get_input_arguments():

    parser = argparse.ArgumentParser(description='Get NN arguments')
    #Define arguments
    parser.add_argument('data_dir', type=str, help='mandatory data directory')
    parser.add_argument('--arch', default='vgg13', help='default architecture, options: vgg13, densenet121')
    parser.add_argument('--hidden_layers', default=[4096,4096], help='default hidden layer sizes')
    parser.add_argument('--output_size', default=102, type=int, help='default output_size')
    parser.add_argument('--learning_rate', default=0.001, type=float, help='default learning rate' )
    parser.add_argument('--drop_p', default = 0.3, type = float, help = 'default drop out rate')
    parser.add_argument('--epochs', default=20, type=int, help='default training epochs')
    parser.add_argument('--is_gpu', default=True, action='store_true', help='choose GPU processing')

    return parser.parse_args()

def main():
    in_args = get_input_arguments()
    trainloader, testloader, valiloader, class_to_idx = load_dataset(in_args.data_dir)
    model, input_size= choose_network(in_args.arch)
    model, criterion, optimizer = create_classifier(model, input_size, in_args.output_size, in_args.hidden_layers, class_to_idx,in_args.learning_rate, in_args.drop_p)
    model = train_classifier(model, trainloader, valiloader, criterion, optimizer, in_args.epochs, in_args.is_gpu, print_every = 40)
    test_classifier(model, criterion, testloader, in_args.is_gpu)

    save_model(input_size, in_args.output_size, in_args.hidden_layers, in_args.learning_rate, in_args.arch, model, optimizer, in_args.epochs)
    pass

if __name__ == '__main__':
    main()
