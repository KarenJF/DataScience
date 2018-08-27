# Class Prediction

# load library

# Imports common Python library
import numpy as np
import matplotlib.pyplot as plt

# Imports pytorch
import torch
from torch import nn # import neural network
from torch import optim # import optimization
from torch.autograd import Variable
import torch.nn.functional as F
from torchvision import datasets, transforms, models

import argparse
import json
import sys
from PIL import Image

# load the model
def load_checkpoint(filepath):
    '''
    Purpose: load a trained model 
    Input:
    filepath: location and name of the trained model
    output: 
    model: load the trained model to rebuilt a model
    '''
    
    checkpoint = torch.load(filepath)
    arch = checkpoint['arch']
    
    if arch == 'vgg13':
        model = models.vgg13(pretrained = True)
    elif arch == 'densenet121':
        model = models.densenet121(pretrained = True)
    else: 
        print('{} architecture not recognized. Supported args: \'vgg\' or \'densenet\''.format(arch))
        sys.exit()
   
    for param in model.parameters():
        param.requires_grad = False
        
    model.classifier = checkpoint['classifier']
    model.load_state_dict(checkpoint['state_dict'])
    model.class_to_idx = checkpoint['class_to_idx']
    
    return model

# procss image
def process_image(image_path):
    ''' 
    Purpose: Scales, crops, and normalizes a PIL image for a PyTorch model, returns an Numpy array
    Input: 
    image_path: image location and name
    Return: 
    np_image: numpy arrary of the image
    '''
    process_transforms = transforms.Compose([transforms.Resize(256),
                                             transforms.CenterCrop(224),
                                             transforms.ToTensor(),
                                             transforms.Normalize([0.485, 0.456, 0.406],[0.229, 0.224, 0.225])])

    im = Image.open(image_path)
    pil_image = process_transforms(im).float()
    np_image = np.array(pil_image)

    return np_image

def predict(image_path,model,is_gpu, k):
    '''
    Purpose: use a trained model to predict image
    Input: 
    image_path: image for prediction
    model: a trained model
    k: top k
    is_gpu: select whether evaluating under gpu or cpu
    
    Output: 
    probs: probability for prediction
    classes: prediction
    '''
    # put the model in eval mode
    model.eval()

    # change to cuda if avaliable
    if is_gpu and torch.cuda.is_available(): 
        device = "cuda"
        print("Current training is under GPU")
    else: 
        device = "cpu"
        print("Current training is under CPU")
    
    model = model.to(device)

    # load an image for prediction. This image is in numpy array format. In order to use it in our model, we need to
    # convert it back to Tensor matrix
    img = process_image(image_path)

    # convert numpy arrary back to tensor with the right format
    img2 = torch.from_numpy(img).unsqueeze(0)

    # move img2 to cuda
    img2 = img2.to(torch.device(device))

    #put the image to the model for prediction
    with torch.no_grad():
        output = model.forward(img2)
        results = torch.exp(output).data.topk(k)
    # get probabilities and classes
    
    classes = np.array(results[1][0], dtype=np.int)
    probs = Variable(results[0][0]).data
    
   # probs, classes = output.topk(k)

    # model is in logsoftmax, use exp() to convert back to probabilities
    # since the format is Tensor, convert back to numpy array
  #  Tensor.cpu() 
  #  ps = torch.exp(probs)
  #  probs = ps.numpy()[0]
  #  classes = classes.numpy()[0]

    # map classes back to class keys
    keys = {x:y for y, x in model.class_to_idx.items()}
    classes = [keys[i] for i in classes]

    # print(probs)
    # print(classes)

    return probs, classes

# sanity check
# Use the image as input to run in the model
def print_prediction(image_path, model, is_gpu,k):
    '''
    Purpose: predict a image and print out the result
    Input: 
    image_path: image for prediction
    model: model to use for prediction
    '''
    probs, classes = predict(image_path, model,is_gpu,k)

    print("Prob: ", probs)
    print("Classes: ", classes)

    with open('cat_to_name.json', 'r') as f:
        cat_to_name = json.load(f)

    y = np.arange(len(classes))
    y_labels = [cat_to_name.get(i) for i in classes]

    fig, ax = plt.subplots()
    ax.set_yticks(y)
    ax.set_yticklabels(y_labels)

    # invert y-axis to match with final graph example
    ax.invert_yaxis()

    plt.barh(y,probs)
    pass

# run command
def get_input_arguments():

    parser = argparse.ArgumentParser(description='Get NN arguments')
    #Define arguments
    parser.add_argument('filepath', type=str, help='load checkpoint')
    parser.add_argument('image_path', type=str, help='image directory to process and predict')
    parser.add_argument('--k', default=5, type=int, help='default top_k results')
    parser.add_argument('--is_gpu', default=True, action='store_true', help='select GPU processing')

    return parser.parse_args()

def main():
    in_args = get_input_arguments()
    model = load_checkpoint(in_args.filepath)
    probs, classes = predict(in_args.image_path, model, in_args.is_gpu, in_args.k)
    print_prediction(in_args.image_path, model, in_args.is_gpu, in_args.k)
    pass

if __name__ == '__main__':
    main()
